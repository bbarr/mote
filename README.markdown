# Mote
Mote aims to be a simple, light weight MongoDB abstraction layer built on top of the
Ruby driver.

Wherever possible, operations are delegated directly to the Ruby driver without
much interference in order to provide the most lightweight solution as possible.
The main goal of Mote is to DRY up regular activities that are run when dealing
with the database.

## Getting started
### Create a connection to the database
`Mote.db = Mongo::Connection.new.db("my_db", :pk => Mote::PkFactory)`

Mote provides a custom PkFactory for use when generating IDs.  The PkFactory simply
overwrites the way that the key is added to the document. Currently, the Ruby driver
creates a property in the document's hash named _id as a symbol. This happens to behave
quite differently from the rest of the operations done by the driver where keys are
stored as strings instead of keys.

### Your first model
`class Book < Mote::Document; end`

That's it, your ready to use Mote's baseline convenience methods.

Mote follows the same convention as ActiveRecord when it comes to collections and
individual documents. Meaning, a collection will be inferred as the pluralized version
of the class's name.

With our model above, the collection will be called books.
