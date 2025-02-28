# Inventory Management

## Requirements
- Docker
- Ruby (version 3.1.2)
- Rails (version 7.0)
- Bundler

## External Dependencies
- PostgreSQL
- Node.js

## Docker
```python
docker pull paulinewade/csce431:latest

## Docker
```python
docker pull paulinewade/csce431:latest
```
```python
docker run --rm -it --volume "$(pwd):/csce431" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 paulinewade/csce431:latest
```

## How to Run
```ruby
bundle install
```
```ruby
rails db:migrate
```
```ruby
rails s -b 0.0.0.0
```
