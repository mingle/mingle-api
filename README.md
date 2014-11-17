# Mingle::Api

[Built with :yellow_heart: and :coffee: in San Francisco](http://getmingle.io)

[Mingle](http://getmingle.io) is a software development team collaborative tool, developed by ThoughtWorks Studios.
The Mingle API gem provides simple interface for you to build application talks to Mingle.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mingle-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mingle-api

## Usage

### Initialize with HMac Auth for SaaS Mingle site

    mingle = Mingle.new('site-name', hmac: [username, secret_key])

### Initialize with Basic Auth for SaaS Mingle site

    mingle = Mingle.new('site-name', basic_auth: [username, password])

### Initialize with HMac for onsite Mingle site

    mingle = Mingle.new('https://your-mingle-site-url', hmac: [username, secret_key])

### Get all projects

    projects = mingle.projects

### Get project by identifier

    project = mingle.projects('your_first_project')

### Create project

    mingle.create_project("Project Name")
    # => OpenStruct.new(identifier, url)

Create with project description and from template

    mingle.create_project("Project Name", description: "description", template: 'kanban')

### Get first page cards in project

    mingle.cards('project_identifier')

### Get card by card number and project identifier

Let's say you have a project named Mingle and its identifier is mingle,
and card number 123 has a text property named Status and user property named Owner

    mingle.card('mingle', 123)

You will get an OpenStruct object with attributes: name, description, type, status, owner
As Owner is a user property, the value of the owner will be the user login if it exists

### Create card

    mingle.create_card('project_identifier', name: 'card name', type: 'Story',
      attachments: [['/path/to/file', "image/png"]],
      properties: {status: 'New', priority: 'high'})
    # => OpenStruct.new(number, url)

## API design

1. flat: one level API, you can find all APIs definition in class Mingle.
2. data: all APIs return data object only, they are:
   1. Primitive type in Ruby
   2. OpenStruct object, with primitive type values (rule #1 flat)

## Setup development environment

See .rbenv-vars file for environment variables need for test.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mingle-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
