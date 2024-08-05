Active Record Basics

This guide is an introduction to Active Record.

After reading this guide, you will know:

    What Object Relational Mapping and Active Record are and how they are used in Rails.
    How Active Record fits into the Model-View-Controller paradigm.
    How to use Active Record models to manipulate data stored in a relational database.
    Active Record schema naming conventions.
    The concepts of database migrations, validations, callbacks, and associations.

Chapters

    What is Active Record?
        The Active Record Pattern
        Object Relational Mapping
        Active Record as an ORM Framework
    Convention over Configuration in Active Record
        Naming Conventions
        Schema Conventions
    Creating Active Record Models
    Overriding the Naming Conventions
    CRUD: Reading and Writing Data
        Create
        Read
        Update
        Delete
    Validations
    Callbacks
    Migrations
    Associations

1 What is Active Record?

Active Record is the M in MVC - the model - which is the layer of the system responsible for representing business data and logic. Active Record facilitates the creation and use of business objects whose data requires persistent storage to a database. It is an implementation of the Active Record pattern which itself is a description of an Object Relational Mapping system.
1.1 The Active Record Pattern

Active Record was described by Martin Fowler in his book Patterns of Enterprise Application Architecture. In Active Record, objects carry both persistent data and behavior which operates on that data. Active Record takes the opinion that ensuring data access logic as part of the object will educate users of that object on how to write to and read from the database.
1.2 Object Relational Mapping

Object Relational Mapping, commonly referred to as its abbreviation ORM, is a technique that connects the rich objects of an application to tables in a relational database management system. Using ORM, the properties and relationships of the objects in an application can be easily stored and retrieved from a database without writing SQL statements directly and with less overall database access code.

Basic knowledge of relational database management systems (RDBMS) and structured query language (SQL) is helpful in order to fully understand Active Record. Please refer to this tutorial (or this one) or study them by other means if you would like to learn more.
1.3 Active Record as an ORM Framework

Active Record gives us several mechanisms, the most important being the ability to:

    Represent models and their data.
    Represent associations between these models.
    Represent inheritance hierarchies through related models.
    Validate models before they get persisted to the database.
    Perform database operations in an object-oriented fashion.

2 Convention over Configuration in Active Record

When writing applications using other programming languages or frameworks, it may be necessary to write a lot of configuration code. This is particularly true for ORM frameworks in general. However, if you follow the conventions adopted by Rails, you'll need to write very little configuration (in some cases no configuration at all) when creating Active Record models. The idea is that if you configure your applications in the very same way most of the time then this should be the default way. Thus, explicit configuration would be needed only in those cases where you can't follow the standard convention.
2.1 Naming Conventions

By default, Active Record uses some naming conventions to find out how the mapping between models and database tables should be created. Rails will pluralize your class names to find the respective database table. So, for a class Book, you should have a database table called books. The Rails pluralization mechanisms are very powerful, being capable of pluralizing (and singularizing) both regular and irregular words. When using class names composed of two or more words, the model class name should follow the Ruby conventions, using the CamelCase form, while the table name must use the snake_case form. Examples:

    Model Class - Singular with the first letter of each word capitalized (e.g., BookClub).
    Database Table - Plural with underscores separating words (e.g., book_clubs).

Model / Class 	Table / Schema
Article 	articles
LineItem 	line_items
Deer 	deers
Mouse 	mice
Person 	people
2.2 Schema Conventions

Active Record uses naming conventions for the columns in database tables, depending on the purpose of these columns.

    Foreign keys - These fields should be named following the pattern singularized_table_name_id (e.g., item_id, order_id). These are the fields that Active Record will look for when you create associations between your models.
    Primary keys - By default, Active Record will use an integer column named id as the table's primary key (bigint for PostgreSQL and MySQL, integer for SQLite). When using Active Record Migrations to create your tables, this column will be automatically created.

There are also some optional column names that will add additional features to Active Record instances:

    created_at - Automatically gets set to the current date and time when the record is first created.
    updated_at - Automatically gets set to the current date and time whenever the record is created or updated.
    lock_version - Adds optimistic locking to a model.
    type - Specifies that the model uses Single Table Inheritance.
    (association_name)_type - Stores the type for polymorphic associations.
    (table_name)_count - Used to cache the number of belonging objects on associations. For example, a comments_count column in an Article class that has many instances of Comment will cache the number of existent comments for each article.

While these column names are optional, they are in fact reserved by Active Record. Steer clear of reserved keywords unless you want the extra functionality. For example, type is a reserved keyword used to designate a table using Single Table Inheritance (STI). If you are not using STI, try an analogous keyword like "context", that may still accurately describe the data you are modeling.
3 Creating Active Record Models

When generating an application, an abstract ApplicationRecord class will be created in app/models/application_record.rb. This is the base class for all models in an app, and it's what turns a regular ruby class into an Active Record model.

To create Active Record models, subclass the ApplicationRecord class and you're good to go:

class Product < ApplicationRecord
end

This will create a Product model, mapped to a products table at the database. By doing this you'll also have the ability to map the columns of each row in that table with the attributes of the instances of your model. Suppose that the products table was created using an SQL (or one of its extensions) statement like:

CREATE TABLE products (
  id int(11) NOT NULL auto_increment,
  name varchar(255),
  PRIMARY KEY  (id)
);

The schema above declares a table with two columns: id and name. Each row of this table represents a certain product with these two parameters. Thus, you would be able to write code like the following:

p = Product.new
p.name = "Some Book"
puts p.name # "Some Book"

4 Overriding the Naming Conventions

What if you need to follow a different naming convention or need to use your Rails application with a legacy database? No problem, you can easily override the default conventions.

Since ApplicationRecord inherits from ActiveRecord::Base, your application's models will have a number of helpful methods available to them. For example, you can use the ActiveRecord::Base.table_name= method to customize the table name that should be used:

class Product < ApplicationRecord
  self.table_name = "my_products"
end

If you do so, you will have to manually define the class name that is hosting the fixtures (my_products.yml) using the set_fixture_class method in your test definition:

# test/models/product_test.rb
class ProductTest < ActiveSupport::TestCase
  set_fixture_class my_products: Product
  fixtures :my_products
  # ...
end

It's also possible to override the column that should be used as the table's primary key using the ActiveRecord::Base.primary_key= method:

class Product < ApplicationRecord
  self.primary_key = "product_id"
end

Active Record does not recommend using non-primary key columns named id. Using a column named id which is not a single-column primary key complicates the access to the column value. The application will have to use the id_value alias attribute to access the value of the non-PK id column.

If you try to create a column named id which is not the primary key, Rails will throw an error during migrations such as: you can't redefine the primary key column 'id' on 'my_products'. To define a custom primary key, pass { id: false } to create_table.
5 CRUD: Reading and Writing Data

CRUD is an acronym for the four verbs we use to operate on data: Create, Read, Update and Delete. Active Record automatically creates methods to allow an application to read and manipulate data stored within its tables.
5.1 Create

Active Record objects can be created from a hash, a block, or have their attributes manually set after creation. The new method will return a new object while create will return the object and save it to the database.

For example, given a model User with attributes of name and occupation, the create method call will create and save a new record into the database:

user = User.create(name: "David", occupation: "Code Artist")

Using the new method, an object can be instantiated without being saved:

user = User.new
user.name = "David"
user.occupation = "Code Artist"

A call to user.save will commit the record to the database.

Finally, if a block is provided, both create and new will yield the new object to that block for initialization, while only create will persist the resulting object to the database:

user = User.new do |u|
  u.name = "David"
  u.occupation = "Code Artist"
end

5.2 Read

Active Record provides a rich API for accessing data within a database. Below are a few examples of different data access methods provided by Active Record.

# return a collection with all users
users = User.all

# return the first user
user = User.first

# return the first user named David
david = User.find_by(name: 'David')

# find all users named David who are Code Artists and sort by created_at in reverse chronological order
users = User.where(name: 'David', occupation: 'Code Artist').order(created_at: :desc)

You can learn more about querying an Active Record model in the Active Record Query Interface guide.
5.3 Update

Once an Active Record object has been retrieved, its attributes can be modified and it can be saved to the database.

user = User.find_by(name: 'David')
user.name = 'Dave'
user.save

A shorthand for this is to use a hash mapping attribute names to the desired value, like so:

user = User.find_by(name: 'David')
user.update(name: 'Dave')

This is most useful when updating several attributes at once.

If you'd like to update several records in bulk without callbacks or validations, you can update the database directly using update_all:

User.update_all max_login_attempts: 3, must_change_password: true

5.4 Delete

Likewise, once retrieved, an Active Record object can be destroyed, which removes it from the database.

user = User.find_by(name: 'David')
user.destroy

If you'd like to delete several records in bulk, you may use destroy_by or destroy_all method:

# find and delete all users named David
User.destroy_by(name: 'David')

# delete all users
User.destroy_all

6 Validations

Active Record allows you to validate the state of a model before it gets written into the database. There are several methods that you can use to check your models and validate that an attribute value is not empty, is unique and not already in the database, follows a specific format, and many more.

Methods like save, create and update validate a model before persisting it to the database. When a model is invalid these methods return false and no database operations are performed. All of these methods have a bang counterpart (that is, save!, create! and update!), which are stricter in that they raise an ActiveRecord::RecordInvalid exception when validation fails. A quick example to illustrate:

class User < ApplicationRecord
  validates :name, presence: true
end

irb> user = User.new
irb> user.save
=> false
irb> user.save!
ActiveRecord::RecordInvalid: Validation failed: Name can't be blank

You can learn more about validations in the Active Record Validations guide.
7 Callbacks

Active Record callbacks allow you to attach code to certain events in the life-cycle of your models. This enables you to add behavior to your models by transparently executing code when those events occur, like when you create a new record, update it, destroy it, and so on.

class User < ApplicationRecord
  after_create :log_new_user

  private
    def log_new_user
      puts "A new user was registered"
    end
end

irb> @user = User.create
A new user was registered

You can learn more about callbacks in the Active Record Callbacks guide.
8 Migrations

Rails provides a convenient way to manage changes to a database schema via migrations. Migrations are written in a domain-specific language and stored in files which are executed against any database that Active Record supports.

Here's a migration that creates a new table called publications:

class CreatePublications < ActiveRecord::Migration[7.1]
  def change
    create_table :publications do |t|
      t.string :title
      t.text :description
      t.references :publication_type
      t.references :publisher, polymorphic: true
      t.boolean :single_issue

      t.timestamps
    end
  end
end

Note that the above code is database-agnostic: it will run in MySQL, PostgreSQL, SQLite, and others.

Rails keeps track of which migrations have been committed to the database and stores them in a neighboring table in that same database called schema_migrations.

To run the migration and create the table, you'd run bin/rails db:migrate, and to roll it back and delete the table, bin/rails db:rollback.

You can learn more about migrations in the Active Record Migrations guide.
9 Associations

Active Record associations allow you to define relationships between models. Associations can be used to describe one-to-one, one-to-many, and many-to-many relationships. For example, a relationship like “Author has many Books” can be defined as follows:

class Author < ApplicationRecord
  has_many :books
end

The Author class now has methods to add and remove books to an author, and much more.

You can learn more about associations in the Active Record Associations guide.
Feedback

You're encouraged to help improve the quality of this guide.

Please contribute if you see any typos or factual errors. To get started, you can read our documentation contributions section.

You may also find incomplete content or stuff that is not up to date. Please do add any missing documentation for main. Make sure to check Edge Guides first to verify if the issues are already fixed or not on the main branch. Check the Ruby on Rails Guides Guidelines for style and conventions.

If for whatever reason you spot something to fix but cannot patch it yourself, please open an issue.

And last but not least, any kind of discussion regarding Ruby on Rails documentation is very welcome on the official Ruby on Rails Forum.

This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License

"Rails", "Ruby on Rails", and the Rails logo are trademarks of David Heinemeier Hansson. All rights reserved.
