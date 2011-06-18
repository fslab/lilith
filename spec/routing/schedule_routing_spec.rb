require 'spec_helper'

describe "routing for Schedules" do
  include SchedulesHelper

  context "schedules resource" do
    context "index action" do
      it "should route /schedules with and without specified locale" do
        get('/schedules').should route_to(
          :controller => 'schedules', :action => 'index')

        get('/de/schedules').should route_to(
          :controller => 'schedules', :action => 'index', :locale => 'de')

        get('/en/schedules').should route_to(
          :controller => 'schedules', :action => 'index', :locale => 'en')
      end

      it "should route schedules_path with and without specified locale" do
        get(schedules_path).should route_to(
          :controller => 'schedules', :action => 'index')

        get(schedules_path(:locale => :de)).should route_to(
          :controller => 'schedules', :action => 'index', :locale => 'de')

        get(schedules_path(:locale => :en)).should route_to(
          :controller => 'schedules', :action => 'index', :locale => 'en')
      end
    end

    context "new action" do
      it "should route /schedules/new with and without specified locale" do
        get('/schedules/new').should route_to(
          :controller => 'schedules', :action => 'new')

        get('/de/schedules/new').should route_to(
          :controller => 'schedules', :action => 'new', :locale => 'de')

        get('/en/schedules/new').should route_to(
          :controller => 'schedules', :action => 'new', :locale => 'en')
      end

      it "should route new_schedule_path with and without specified locale" do
        get(new_schedule_path).should route_to(
          :controller => 'schedules', :action => 'new')

        get(new_schedule_path(:locale => :de)).should route_to(
          :controller => 'schedules', :action => 'new', :locale => 'de')

        get(new_schedule_path(:locale => :en)).should route_to(
          :controller => 'schedules', :action => 'new', :locale => 'en')
      end
    end

    context "create action" do
      it "should route /schedules via POST with and without specified locale" do
        post('/schedules').should route_to(
          :controller => 'schedules', :action => 'create')

        post('/de/schedules').should route_to(
          :controller => 'schedules', :action => 'create', :locale => 'de')

        post('/en/schedules').should route_to(
          :controller => 'schedules', :action => 'create', :locale => 'en')
      end

      it "should route schedule_path via POST with and without specified locale" do
        post(schedules_path).should route_to(
          :controller => 'schedules', :action => 'create')

        post(schedules_path(:locale => :de)).should route_to(
          :controller => 'schedules', :action => 'create', :locale => 'de')

        post(schedules_path(:locale => :en)).should route_to(
          :controller => 'schedules', :action => 'create', :locale => 'en')
      end
    end

    context "show action" do
      before(:all) do
        @expected_route = {:controller => 'schedules', :action => 'show', :id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f'}
      end

      it "should route /schedules/:id with and without specified locale" do
        get('/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(@expected_route)
        get('/de/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(
          @expected_route.merge(:locale => 'de'))
        get('/en/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(
          @expected_route.merge(:locale => 'en'))
      end

      it "should route schedule_path with and without specified locale" do
        get(schedule_path(:id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f')).should route_to(@expected_route)
        get(schedule_path(:id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f', :locale => :de)).should route_to(
          @expected_route.merge(:locale => 'de'))
        get(schedule_path(:id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f', :locale => :en)).should route_to(
          @expected_route.merge(:locale => 'en'))
      end
    end

    context "edit action" do
      before(:all) do
        @expected_route = {:controller => 'schedules', :action => 'edit', :id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f'}
      end

      it "should route /schedules/:id/edit with and without specified locale" do
        get('/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f/edit').should route_to(@expected_route)
        get('/de/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f/edit').should route_to(
          @expected_route.merge(:locale => 'de'))
        get('/en/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f/edit').should route_to(
          @expected_route.merge(:locale => 'en'))
      end

      it "should route edit_schedule_path with and without specified locale" do
        get(edit_schedule_path(:id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f')).should route_to(@expected_route)
        get(edit_schedule_path(:id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f', :locale => :de)).should route_to(
          @expected_route.merge(:locale => 'de'))
        get(edit_schedule_path(:id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f', :locale => :en)).should route_to(
          @expected_route.merge(:locale => 'en'))
      end
    end

    context "update action" do
      before(:all) do
        @expected_route = {:controller => 'schedules', :action => 'update', :id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f'}
      end

      it "should route /schedules/:id via PUT with and without specified locale" do
        put('/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(@expected_route)
        put('/de/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(
          @expected_route.merge(:locale => 'de'))
        put('/en/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(
          @expected_route.merge(:locale => 'en'))
      end

      it "should route schedule_path via PUT with and without specified locale" do
        put(schedule_path(:id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f')).should route_to(@expected_route)
        put(schedule_path(:id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f', :locale => :de)).should route_to(
          @expected_route.merge(:locale => 'de'))
        put(schedule_path(:id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f', :locale => :en)).should route_to(
          @expected_route.merge(:locale => 'en'))
      end
    end

    context "destroy action" do
      before(:all) do
        @expected_route = {:controller => 'schedules', :action => 'destroy', :id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f'}
      end

      it "should route /schedules/:id via DELETE with and without specified locale" do
        delete('/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(@expected_route)
        delete('/de/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(
          @expected_route.merge(:locale => 'de'))
        delete('/en/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(
          @expected_route.merge(:locale => 'en'))
      end

      it "should route schedule_path via DELETE with and without specified locale" do
        delete(schedule_path(:id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f')).should route_to(@expected_route)
        delete(schedule_path(:id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f', :locale => :de)).should route_to(
          @expected_route.merge(:locale => 'de'))
        delete(schedule_path(:id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f', :locale => :en)).should route_to(
          @expected_route.merge(:locale => 'en'))
      end
    end
  end

  context "users nested schedules resource" do
    context "index action" do
      before(:all) do
        @expected_route = {:controller => 'schedules', :action => 'index', :user_id => 'kmuster2s'}
      end

      it "should route /user/:user_id/schedules with and without specified locale" do
        get('/users/kmuster2s/schedules').should route_to(@expected_route)
        get('/de/users/kmuster2s/schedules').should route_to(@expected_route.merge(:locale => 'de'))
        get('/en/users/kmuster2s/schedules').should route_to(@expected_route.merge(:locale => 'en'))
      end

      it "should route users_schedules_path with and without specified locale" do
        get(user_schedules_path(:user_id => 'kmuster2s')).should route_to(@expected_route)
        get(user_schedules_path(:user_id => 'kmuster2s', :locale => :de)).should route_to(
          @expected_route.merge(:locale => 'de'))
        get(user_schedules_path(:user_id => 'kmuster2s', :locale => :en)).should route_to(
          @expected_route.merge(:locale => 'en'))
      end
    end

    context "new action" do
      before(:all) do
        @expected_route = {:controller => 'schedules', :action => 'new', :user_id => 'kmuster2s'}
      end
      
      it "should route /users/:user_id/schedules/new with and without specified locale" do
        get('/users/kmuster2s/schedules/new').should route_to(@expected_route)
        get('/de/users/kmuster2s/schedules/new').should route_to(@expected_route.merge(:locale => 'de'))
        get('/en/users/kmuster2s/schedules/new').should route_to(@expected_route.merge(:locale => 'en'))
      end

      it "should route new_user_schedule_path with and without specified locale" do
        get(new_user_schedule_path(:user_id => 'kmuster2s')).should route_to(@expected_route)
        get(new_user_schedule_path(:user_id => 'kmuster2s', :locale => :de)).should route_to(
          @expected_route.merge(:locale => 'de'))
        get(new_user_schedule_path(:user_id => 'kmuster2s', :locale => :en)).should route_to(
          @expected_route.merge(:locale => 'en'))
      end
    end

    context "create action" do
      before(:all) do
        @expected_route = {:controller => 'schedules', :action => 'create', :user_id => 'kmuster2s'}
      end

      it "should route /users/:user_id/schedules via POST with and without specified locale" do
        post('/users/kmuster2s/schedules').should route_to(@expected_route)
        post('/de/users/kmuster2s/schedules').should route_to(@expected_route.merge(:locale => 'de'))
        post('/en/users/kmuster2s/schedules').should route_to(@expected_route.merge(:locale => 'en'))
      end

      it "should route user_schedule_path via POST with and without specified locale" do
        post(user_schedules_path(:user_id => 'kmuster2s')).should route_to(@expected_route)
        post(user_schedules_path(:user_id => 'kmuster2s', :locale => :de)).should route_to(
          @expected_route.merge(:locale => 'de'))
        post(user_schedules_path(:user_id => 'kmuster2s', :locale => :en)).should route_to(
          @expected_route.merge(:locale => 'en'))
      end
    end

    context "show action" do
      before(:all) do
        @expected_route = {:controller => 'schedules', :action => 'show', :user_id => 'kmuster2s', :id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f'}
      end

      it "should route /users/:user_id/schedules/:id with and without specified locale" do
        get('/users/kmuster2s/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(@expected_route)
        get('/de/users/kmuster2s/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(
          @expected_route.merge(:locale => 'de'))
        get('/en/users/kmuster2s/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(
          @expected_route.merge(:locale => 'en'))
      end

      it "should route user_schedule_path with and without specified locale" do
        options = {:user_id => 'kmuster2s', :id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f'}

        get(user_schedule_path(options)).should route_to(@expected_route)
        get(user_schedule_path(options.merge(:locale => :de))).should route_to(
          @expected_route.merge(:locale => 'de'))
        get(user_schedule_path(options.merge(:locale => :en))).should route_to(
          @expected_route.merge(:locale => 'en'))
      end
    end

    context "edit action" do
      before(:all) do
        @expected_route = {:controller => 'schedules', :action => 'edit', :user_id => 'kmuster2s', :id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f'}
      end
      
      it "should route /users/:user_id/schedules/:id/edit with and without specified locale" do
        get('/users/kmuster2s/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f/edit').should route_to(@expected_route)
        get('/de/users/kmuster2s/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f/edit').should route_to(
          @expected_route.merge(:locale => 'de'))
        get('/en/users/kmuster2s/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f/edit').should route_to(
          @expected_route.merge(:locale => 'en'))
      end

      it "should route edit_user_schedule_path with and without specified locale" do
        options = {:user_id => 'kmuster2s', :id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f'}

        get(edit_user_schedule_path(options)).should route_to(@expected_route)
        get(edit_user_schedule_path(options.merge(:locale => :de))).should route_to(
          @expected_route.merge(:locale => 'de'))
        get(edit_user_schedule_path(options.merge(:locale => :en))).should route_to(
          @expected_route.merge(:locale => 'en'))
      end
    end

    context "update action" do
      before(:all) do
        @expected_route = {:controller => 'schedules', :action => 'update', :user_id => 'kmuster2s', :id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f'}
      end

      it "should route /users/:user_id/schedules/:id via PUT with and without specified locale" do
        put('/users/kmuster2s/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(@expected_route)
        put('/de/users/kmuster2s/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(
          @expected_route.merge(:locale => 'de'))
        put('/en/users/kmuster2s/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(
          @expected_route.merge(:locale => 'en'))
      end

      it "should route user_schedule_path via PUT with and without specified locale" do
        options = {:user_id => 'kmuster2s', :id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f'}

        put(user_schedule_path(options)).should route_to(@expected_route)
        put(user_schedule_path(options.merge(:locale => :de))).should route_to(
          @expected_route.merge(:locale => 'de'))
        put(user_schedule_path(options.merge(:locale => :en))).should route_to(
          @expected_route.merge(:locale => 'en'))
      end
    end

    context "destroy action" do
      before(:all) do
        @expected_route = {:controller => 'schedules', :action => 'destroy', :user_id => 'kmuster2s', :id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f'}
      end

      it "should route /users/:user_id/schedules/:id via DELETE with and without specified locale" do
        delete('/users/kmuster2s/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(@expected_route)
        delete('/de/users/kmuster2s/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(
          @expected_route.merge(:locale => 'de'))
        delete('/en/users/kmuster2s/schedules/7d5e66a0-99b0-11e0-9624-002186a0cd2f').should route_to(
          @expected_route.merge(:locale => 'en'))
      end

      it "should route schedule_path via DELETE with and without specified locale" do
        options = {:user_id => 'kmuster2s', :id => '7d5e66a0-99b0-11e0-9624-002186a0cd2f'}

        delete(user_schedule_path(options)).should route_to(@expected_route)
        delete(user_schedule_path(options.merge(:locale => :de))).should route_to(
          @expected_route.merge(:locale => 'de'))
        delete(user_schedule_path(options.merge(:locale => :en))).should route_to(
          @expected_route.merge(:locale => 'en'))
      end
    end
  end

  context "intelligent schedule_path named route" do
    context "show action" do
      it "should route via schedules resource if persisted but temporary" do
        schedule = Schedule.make!(:name => nil)

        get(schedule_path(schedule)).should route_to(
          :controller => 'schedules', :action => 'show', :id => schedule.id)

        get(schedule_path(schedule, :locale => :de)).should route_to(
          :controller => 'schedules', :action => 'show', :id => schedule.id, :locale => 'de')

        get(schedule_path(schedule, :locale => :en)).should route_to(
          :controller => 'schedules', :action => 'show', :id => schedule.id, :locale => 'en')
      end

      it "should route via users nested schedules resource if persisted and permanent" do
        schedule = Schedule.make!(:name => 'my_schedule')

        get(schedule_path(schedule)).should route_to(
          :controller => 'schedules', :action => 'show', :user_id => schedule.user.login, :id => schedule.name)

        get(schedule_path(schedule, :locale => :en)).should route_to(
          :controller => 'schedules', :action => 'show', :user_id => schedule.user.login, :id => schedule.name, :locale => 'en')

        get(schedule_path(schedule, :locale => :de)).should route_to(
          :controller => 'schedules', :action => 'show', :user_id => schedule.user.login, :id => schedule.name, :locale => 'de')
      end
    end

    context "edit action" do
      it "should route via schedules resource if persisted but temporary" do
        schedule = Schedule.make!(:name => nil)

        get(edit_schedule_path(schedule)).should route_to(
          :controller => 'schedules', :action => 'edit', :id => schedule.id)

        get(edit_schedule_path(schedule, :locale => :de)).should route_to(
          :controller => 'schedules', :action => 'edit', :id => schedule.id, :locale => 'de')

        get(edit_schedule_path(schedule, :locale => :en)).should route_to(
          :controller => 'schedules', :action => 'edit', :id => schedule.id, :locale => 'en')
      end

      it "should route via users nested schedules resource if persisted and permanent" do
        schedule = Schedule.make!(:name => 'my_schedule')

        get(edit_schedule_path(schedule)).should route_to(
          :controller => 'schedules', :action => 'edit', :user_id => schedule.user.login, :id => schedule.name)

        get(edit_schedule_path(schedule, :locale => :en)).should route_to(
          :controller => 'schedules', :action => 'edit', :user_id => schedule.user.login, :id => schedule.name, :locale => 'en')

        get(edit_schedule_path(schedule, :locale => :de)).should route_to(
          :controller => 'schedules', :action => 'edit', :user_id => schedule.user.login, :id => schedule.name, :locale => 'de')
      end
    end
  end

end