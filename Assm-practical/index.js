const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on');
require('dotenv').config();
const { createConnection } = require('mysql2/promise');



let app = express();
app.set('view engine', 'hbs');
app.use(express.static('public'));
app.use(express.urlencoded({ extended: false }));

wax.on(hbs.handlebars);
wax.setLayoutPath('./views/layouts');

// require in handlebars and their helpers
const helpers = require('handlebars-helpers');
// tell handlebars-helpers where to find handlebars
helpers({
    'handlebars': hbs.handlebars
})

let connection;

async function main() {
    connection = await createConnection({
        'host': process.env.DB_HOST,
        'user': process.env.DB_USER,
        'database': process.env.DB_NAME,
        'password': process.env.DB_PASSWORD
    });


    app.get('/', (req, res) => {

        res.render('layouts/base', {

        })
    });

    app.get('/customers', async (req, res) => {
        // let [customers] = await connection.execute(`SELECT * FROM Customers 
        //     INNER JOIN Companies ON Customers.company_id = Companies.company_id
        //     `);


        //     SELECT 
        //     Customers.first_name AS customer_first_name,
        //     GROUP_CONCAT(Employees.first_name) AS employee_first_names,
        //     GROUP_CONCAT(Employees.last_name) AS employee_last_names,
        //     Companies.name AS company_name
        // FROM 
        //     Customers
        // JOIN 
        //     Companies ON Customers.company_id = Companies.company_id
        // JOIN 
        //     EmployeeCustomer ON EmployeeCustomer.customer_id = Customers.customer_id
        // JOIN 
        //     Employees ON Employees.employee_id = EmployeeCustomer.employee_id
        // GROUP BY 
        //     Customers.first_name, Companies.name;


        const [customers] = await connection.execute({
            'sql': `
                 SELECT 
        Customers.first_name, Customers.last_name,
        GROUP_CONCAT(CONCAT(" ", Employees.first_name, "  ", Employees.last_name)) AS employee_names,

        Companies.name,Customers.rating
    FROM 
        Customers
    JOIN 
        Companies ON Customers.company_id = Companies.company_id
    JOIN 
        EmployeeCustomer ON EmployeeCustomer.customer_id = Customers.customer_id
    JOIN 
        Employees ON Employees.employee_id = EmployeeCustomer.employee_id
    GROUP BY 
        Customers.first_name, Companies.name, Customers.rating, Customers.last_name
            `,
            nestTables: true

        });

        const formattedCustomers = customers.map(function (eachCustomer) {
            return {
                Customers: eachCustomer.Customers,
                Companies: eachCustomer.Companies,
                employee_names: eachCustomer[""].employee_names
            }
        })
        console.log(formattedCustomers);
        res.render('customers/index', {
            'customers': formattedCustomers,
        })


    })


    // app.get('/customers/create', async(req,res)=>{
    //     let [companies] = await connection.execute('SELECT * from Companies');
    //     res.render('customers/create', {
    //         'companies': companies
    //     })
    // })


    app.get('/customers/create', async (req, res) => {
        let [companies] = await connection.execute('SELECT * from Companies');
        let [employees] = await connection.execute('SELECT * from Employees');
        res.render('customers/create', {
            'companies': companies,
            'employees': employees
        })
    })

    // app.post('/customers/create', async(req,res)=>{
    //     let {first_name, last_name, rating, company_id} = req.body;
    //     let query = 'INSERT INTO Customers (first_name, last_name, rating, company_id) VALUES (?, ?, ?, ?)';
    //     let bindings = [first_name, last_name, rating, company_id];
    //     await connection.execute(query, bindings);
    //     res.redirect('/customers');
    // })

    // 6 Creating Many to Many Relationship
    app.post('/customers/create', async (req, res) => {
        try {
            let { first_name, last_name, rating, company_id, employee_id } = req.body;
            let query = 'INSERT INTO Customers (first_name, last_name, rating, company_id) VALUES (?, ?, ?, ?)';
            let bindings = [first_name, last_name, rating, company_id];
            let [result] = await connection.execute(query, bindings);



            let newCustomerId = result.insertId;
            for (let id of employee_id) {
                let query = 'INSERT INTO EmployeeCustomer (employee_id, customer_id) VALUES (?, ?)';
                let bindings = [id, newCustomerId];
                await connection.execute(query, bindings);
            }

            res.redirect('/customers');
        } catch (e) {
            res.status(400).send("Error " + e);
        }
    })

    // app.get('/customers/:customer_id/edit', async (req, res) => {
    //     let [customers] = await connection.execute('SELECT * from Customers WHERE customer_id = ?', [req.params.customer_id]);
    //     let [companies] = await connection.execute('SELECT * from Companies');
    //     let customer = customers[0];
    //     res.render('customers/edit', {
    //         'customer': customer,
    //         'companies': companies
    //     })
    // })

    // 7. Update a Many to Many Relationship
    app.get('/customers/:customer_id/edit', async (req, res) => {
        let [employees] = await connection.execute('SELECT * from Employees');
        let [companies] = await connection.execute('SELECT * from Companies');
        let [customers] = await connection.execute('SELECT * from Customers WHERE customer_id = ?', [req.params.customer_id]);
        let [employeeCustomers] = await connection.execute('SELECT * from EmployeeCustomer WHERE customer_id = ?', [req.params.customer_id]);

        let customer = customers[0];
        let relatedEmployees = employeeCustomers.map(ec => ec.employee_id);
        // console.log(relatedEmployees);

        res.render('customers/edit', {
            'customer': customer,
            'employees': employees,
            'companies': companies,
            'relatedEmployees': relatedEmployees
        })
    });

    // 5.6 Update
    // app.post('/customers/:customer_id/edit', async (req, res) => {
    //     let {first_name, last_name, rating, company_id} = req.body;
    //     let query = 'UPDATE Customers SET first_name=?, last_name=?, rating=?, company_id=? WHERE customer_id=?';
    //     let bindings = [first_name, last_name, rating, company_id, req.params.customer_id];
    //     await connection.execute(query, bindings);
    //     res.redirect('/customers');
    // })

    // 7. Update a Many to Many Relationship
    app.post('/customers/:customer_id/edit', async (req, res) => {
        let { first_name, last_name, rating, company_id, employee_id } = req.body;

        let query = 'UPDATE Customers SET first_name=?, last_name=?, rating=?, company_id=? WHERE customer_id=?';
        let bindings = [first_name, last_name, rating, company_id, req.params.customer_id];
        await connection.execute(query, bindings);

        await connection.execute('DELETE FROM EmployeeCustomer WHERE customer_id = ?', [req.params.customer_id]);

        for (let id of employee_id) {
            let query = 'INSERT INTO EmployeeCustomer (employee_id, customer_id) VALUES (?, ?)';
            let bindings = [id, req.params.customer_id];
            await connection.execute(query, bindings);
        }

        res.redirect('/customers');
    });





    // delete
    app.get('/customers/:customer_id/delete', async function (req, res) {
        // display a confirmation form 
        const [customers] = await connection.execute(
            "SELECT * FROM Customers WHERE customer_id =?", [req.params.customer_id]
        );
        const customer = customers[0];

        res.render('customers/delete', {
            customer
        })

    })

    app.post('/customers/:customer_id/delete', async function (req, res) {
        await connection.execute(`DELETE FROM EmployeeCustomer WHERE customer_id = ?`, [req.params.customer_id]);
        await connection.execute(`DELETE FROM Customers WHERE customer_id = ?`, [req.params.customer_id]);
        res.redirect('/customers');
    })



    app.listen(3000, () => {
        console.log('Server is running')
    });
}

main();
