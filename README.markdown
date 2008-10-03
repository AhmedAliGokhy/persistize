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
    Person.find_by_full_name('Jimi Hendrix') # #<Person id:1, first_name:"Jimi", last_name:"Hendrix", full_name:"Jimi Hendrix" ...>
  
Dependency
----------

Some times you want to update the field not when the record is changed, but when some other associated records are. For example:

    class Project < ActiveRecord::Base
      has_many :tasks
      
      def completed?
        tasks.any? && tasks.all?(&:completed?)
      end
      
      persistize :completed?, :depending_on => :tasks
      
      named_scope :completed, :conditions => { :completed => true }
      
    end
    
    class Task < ActiveRecord::Base
      belongs_to :project
    end
    
    ...
    
    project = Project.create(:name => 'Rails')
    task = project.tasks.create(:name => 'Make it scale', :completed => false)    
    Project.completed  # []
    
    task.update_attributes(:completed => true)
    Project.completed  # [#<Project id:1, name:"Rails", completed:true ...>]

These examples are just some of the possible applications of this pattern, your imagination is the limit =;-) If you can find a better example, please send it to us.

To-do
-----

* More than one dependency
* More kinds of dependencies (`belongs_to`, `has_one`, `has_many :through`)
* Making cache optional (cache can cause records to be inconsistent if changed and not saved so it would be nice to be able to deactivate it)

Copyright (c) 2008 Luismi Cavallé & Sergio Gil, released under the MIT license
