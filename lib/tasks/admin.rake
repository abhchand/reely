namespace :reely do
  namespace :admin do
    desc "Create a new Reely admin"
    task :create, [:fname, :lname, :email, :password] => [:environment] do |t, args|
      attrs = {
        first_name: args[:fname],
        last_name: args[:lname],
        email: args[:email],
        password: args[:password]
      }

      begin
        user = User.new(attrs)
        user.save!
        user.add_role(:admin)
      rescue => e
        puts e.message
      end
    end
  end
end
