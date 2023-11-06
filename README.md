# BabyApp

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  - v3.2.2

* System dependencies
  - ruby
  - mysql2

* Configuration

* Database creation

  `bin/rails db:create`

* Database initialization

  `bin/rails db:prepare`

* How to run the test suite

  `bundle exec rspec`

* Services (job queues, cache servers, search engines, etc.)

* Develpment Setup instructions

  1. ローカルにDockerをインストールします
  1. docker compose build
  1. docker compose up
  1. ホストPCのブラウザで <http://localhost:3000> へアクセス

* Deployment instructions


* ...

---

![Header Image](/docs/img/header/header.png)

<br />

## Service URL

We have implemented a demo interface with sample data so you can try it out without registration.

https://babyapp.jp/

<br />

## About

Babyapp is an application designed to manage records of activities like feeding and diaper changes for babies. The paper formats provided by maternity wards for record-keeping posed challenges, including limited space for writing, the difficulty of writing in dimly lit conditions at night, and the possibility of forgetting to record due to a busy schedule. To address these issues and as a personal portfolio project, I developed this service. The features incorporated into the app are ones that I personally needed, and whether they would be equally appealing to others is questionable. However, I personally am quite fond of these features.

<br />

## Application Preview
![Application Preview](app/assets/images/babyapp_ss.png)

<br />

## List of Features
| Home Screen | Login Screen |
| ---- | ---- |
| ![Home Screen](/docs/img/app-view/welcome_1.1.png) | ![Login Screen](/docs/img/app-view/login_1.1.png) |
| We have implemented a trial feature that allows you to explore the service without registration. | Authentication with login ID and password is now available. |

| Business Selection Screen | Invoice Creation Screen |
| ---- | ---- |
| ![Business Selection Screen](/docs/img/app-view/select-business_1.1.png) | ![Invoice Creation Screen](/docs/img/app-view/create-invoice_1.1.png) |
| You can now select a business entity from a list of registered businesses to create invoices for. | Features include invoice creation, master data retrieval, tax rate adjustment, and tax rate-specific breakdown calculations, as well as total amount calculations. |

| Invoice Details Screen | PDF Output Screen |
| ---- | ---- |
| ![Invoice Details Screen](/docs/img/app-view/invoice-detail_1.1.png) | ![PDF Output Screen](/docs/img/app-view/print-invoice_1.1.png) |
| This feature allows you to view invoice data. | You can now generate PDF invoices. |

| Master Data Selection Screen | Master Data Registration Screen |
| ---- | ---- |
| ![Master Data Selection Screen](/docs/img/app-view/select-master_1.1.png) | ![Master Data Registration Screen](/docs/img/app-view/master-register-form_1.1.png) |
| We have implemented the functionality to register business information and remarks. | Registering master data enables you to retrieve data when creating invoices. |

<br />

## Technology Stack

| Category          | Technology Stack                                     |
| ----------------- | --------------------------------------------------   |
| Frontend          | html, css(Bootstrap5), js(chart.js, jQuery)                       |
| Backend           | Ruby On Rails                           |
| Infrastructure    | Self-hosted server, nginx, DDNS                         |
| Database          | MySql                                           |
| Monitoring        |                                   |
| Environment setup | Docker                                               |
| CI/CD             |                                        |
| Design            |                                          |
| etc.              | Rubocop, Git, Git flow, GitHub |

<br />

## System Architecture

![System Architecture](/docs/img/system-architecture/system-architecture_1.1.png)

<br />

## Entity-Relationship Diagram (ER Diagram)

![ER Diagram](/docs/img/entity-relationship-diagram/entity-relationship-diagram_1.6.png)

<br />

## Future Outlook

This product is divided into four phases, with development progressing incrementally. Currently, we are in Phase 1, focusing on developing the functionality for creating and issuing invoices. Our ultimate goal is to provide an integrated solution that manages all aspects of document creation, accounting, and financial tasks.

- Phase 1: Develop an application that allows users to create and issue invoices online, including support for new tax regulations.
- Phase 2: Add features to create and issue purchase orders, quotes, and delivery notes online.
- Phase 3: Implement the ability to view financial and transaction data online.
- Phase 4: Add features to efficiently integrate transaction data with accounting software.
