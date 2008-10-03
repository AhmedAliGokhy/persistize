Persistize
==========

Just like `memoize` but stores the value as an attribute in the database. You need to create the field in the database with the name of the method. The field gets updated each time the record is saved:

    class Person < ActiveRecord::Base
    
      def full_name
        "#{first_name} #{last_name}"
      end
  
      persistize :full_name
    
    end
  
    ...
  
    Person.create(:first_name => 'Jimi', :last_name => 'Hendrix')
    Person.find_by_full_name('Jimi Hendrix')
  
This example is just one of the possible applications of this pattern, your imagination is the limit =;-) If you can find a better example, please send it to us.

Copyright (c) 2008 Luismi Cavallé & Sergio Gil, released under the MIT license
