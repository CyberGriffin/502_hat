# Capstone Inventory Management

## Introduction

Capstone Inventory Management is an application designed to manage inventory for the Capstone project at Texas A&M University (TAMU). This system provides functionalities for tracking tools, materials, and equipment to ensure efficient inventory management.

## Requirements

This code has been run and tested on:

- **Ruby** - 3.1.2
- **Rails** - 7.0.3
- **PostgreSQL** - 13.3
- **Node.js** - >=16.x
- **Yarn** - 1.22.x
- **Ruby Gems** - Listed in `Gemfile`

## External Dependencies

The project requires the following external tools:

- **Docker** - Download the latest version at [Docker](https://www.docker.com/products/docker-desktop)
- **Heroku CLI** - Download the latest version at [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)
- **Git** - Download the latest version at [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Installation

To install the project, clone the repository using Git:

```sh
 git clone https://github.com/CyberGriffin/502_hat
```

## Running the Application

To execute the application, follow these steps:

```sh
cd 502_hat
```

Run the application using Docker:

```sh
docker pull paulinewade/csce431:latest
docker run --rm -it --volume "$(pwd):/rails_app" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 paulinewade/csce431:latest
```

Navigate to the Rails application folder:

```sh
cd rails_app
```

Install dependencies and setup the database:

```sh
bundle install && rails webpacker:install && rails db:create && rails db:migrate
```

Start the Rails server:

```sh
rails server --binding=0.0.0.0
```

You can access the application in your browser at [http://localhost:3000/](http://localhost:3000/).

## Running Tests

The project includes an RSpec test suite. To run tests, use the following command:

```sh
rspec spec/
```

## Environment Variables

Google OAuth2 support requires two keys for authentication. To set these up, create a new file called `application.yml` in the `/config` folder and add the following lines:

```yaml
GOOGLE_OAUTH_CLIENT_ID: 'YOUR_GOOGLE_OAUTH_CLIENT_ID_HERE'
GOOGLE_OAUTH_CLIENT_SECRET: 'YOUR_GOOGLE_OAUTH_CLIENT_SECRET_HERE'
```

## Deployment

The application is deployed on **Heroku**. Follow these steps to set up deployment:

1. **Create a Heroku account**: [Sign up here](https://signup.heroku.com/)
2. **Create a new pipeline**: Go to the Heroku dashboard, select `New` -> `Create New Pipeline`
3. **Link GitHub repository**: Link your GitHub repository to the pipeline
4. **Enable review apps**: Enable this option for better CI/CD management
5. **Configure environment variables**:
   - Navigate to the settings tab in the Heroku dashboard
   - Click `Reveal config vars`
   - Add the following keys:
     - `GOOGLE_OAUTH_CLIENT_ID`
     - `GOOGLE_OAUTH_CLIENT_SECRET`
6. **Deploy the app**: Once your pipeline builds the app, click `Open app` to access it

To move the app from staging to production, click the up/down arrows in Heroku and select `Move to production`.

## CI/CD Setup

This project has a **CI/CD pipeline** set up using **GitHub Actions** and **Heroku**:

- **Review app**: Automatically deployed from the `test` branch
- **Production app**: Automatically deployed from the `main` branch
- **Continuous integration**: Runs automated tests, security checks, and linters on every push or pull request

## Support

For support, please refer to the application's help page.