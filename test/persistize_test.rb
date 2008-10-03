require File.dirname(__FILE__) + '/test_helper'

class PersistizeTest < Test::Unit::TestCase
  
  context "persistize" do
  
    setup do
      setup_db
    end
  
    teardown do
      drop_db
    end
  
    context "A person" do
    
      setup do
        @person = Person.create(:first_name => "Jimi", :last_name => "Hendrix")
      end
    
      should "update the value of full name in the database when created" do
        assert_equal('Jimi Hendrix', @person[:full_name])
        assert_equal(@person, Person.find_by_full_name('Jimi Hendrix'))
      end
    
      should "update the value of full name in the database when updated" do
        @person.update_attributes!(:first_name => "Axl", :last_name => "Rose")
        assert_equal('Axl Rose', @person[:full_name])
        assert_equal(@person, Person.find_by_full_name('Axl Rose'))
      end    
    
      should "not update the calculated value until saved" do
        @person.first_name = 'Axl'
        assert_equal('Jimi Hendrix', @person.full_name)
        # TODO: Rethink this behaviour. Do we want to cache or not?
      end
    
      should "call the method when reading before being created" do
        person = Person.new(:first_name => "Jimi", :last_name => "Hendrix")
        assert_equal('Jimi Hendrix', person.full_name)
      end
    
      should "not be able to manually update full name" do
        assert_raise(NoMethodError) { @person.full_name = 'Catacrock' }
      end
    
      should "also persistize #initials" do
        assert_equal('JH', @person[:initials])
      end
    
    end
  
    context "A project with tasks" do
    
      setup do
        @project = Project.create(:name => "Rails")
        @task = @project.tasks.create(:completed => true)
      end
      
      should "update @project#completed? when a new task is created" do
        Task.create(:project_id => @project.id, :completed => false)
        assert !@project.reload.completed?
      end
    
      should "update @project#completed? when a task is deleted" do
        @task.destroy
        assert !@project.reload.completed?
      end
      
      should "update @project#completed? when a task is updated" do
        @task.update_attributes!(:completed => false)
        assert !@project.reload.completed?
      end
    end
  
  end
  
end
