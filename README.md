# Columbo Ruby Client

This gem provides a ruby integration for Columbo. It provides:

* HTTP client
* AMQP client (RabbitMQ implementation only, due to [Bunny](https://github.com/ruby-amqp/bunny) gem dependance)

For integration with Rails applications, see the [columbo-rails-client](https://git.wifirst.net/gems/columbo-rails-client) gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'columbo-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install columbo-client

## Configuration

### Using HTTP

```ruby
Columbo.configure do |config|
  config.system.uid = 'system_uid'
  config.system.label = 'system_label'
  config.system.type = 'system_type'

  config.client = Columbo::Client::HTTP.new('http://example.com/push')
end
```

### Using AMQP

For the AMQP client, the exchange must be configurated through the
`Columbo::Client::AMQP::exchange` method by giving a name and a block
as seen in the example below. `durable`, `auto_delete` and `arguments`
exchange options can also be set as explained in the Bunny gem
[here](http://reference.rubybunny.info/Bunny/Exchange.html#initialize-instance_method).

```ruby
Columbo.configure do |config|
  config.system.uid = 'system_uid'
  config.system.label = 'system_label'
  config.system.type = 'system_type'

  config.client = Columbo::Client::AMQP.new("amqp://guest:guest@localhost:5672")

  config.client.exchange 'exchange-name' do |exchange_options|
    exchange_options.type = 'topic'
    exchange_options.durable = true
  end
end
```

## Usage

We show how to push an event to Columbo by sending the next crafted event:

```ruby
example_event = {
  "system": {
      "uid": "myCompany",
      "type": "application",
      "label": "MyCompany"
  },
  "action": "contact.created",
  "actor": {
      "uid": "john.smith@mycompany.com",
      "type": "commercial",
      "label": "John Smith"
  },
  "resource": {
      "uid": "1",
      "type": "contact",
      "label": "Eric Martin",
      "attributes": {
          "first_name": "Eric",
          "last_name": "Martin",
          "email": "eric.martin@customer.com",
          "phone": "11111111"
      }
  },
  "context": {},
  "related_resources": [],
  "timestamp": "2016-12-29T10:00:00.000000+00:00"
}
```

For each client (HTTP and AMQP), 2 methods are available:

* `publish` will return `true` or `false` depending on the successfulness
  of the publishing.
* `publish!` will raise an error if the publishing fails.

### Using HTTP

The `publish` and `publish!` methods take an event `Hash` as parameter.

```ruby
Columbo.client.publish(example_event)
```

### Using AMQP

The `publish` and `publish!` methods take an event `Hash` as first
parameter and an optional `Hash` parameter. The possible values for
the second parameter are available in Bunny documentation
[here](http://reference.rubybunny.info/Bunny/Exchange.html#publish-instance_method).


```ruby
options[:routing_key] = 'resource.action'

Columbo.client.publish(example_event, options)
```
