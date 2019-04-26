namespace :reely do
  namespace :admin do
    desc "Create a new Reely admin"
    task :create, %i[fname lname email password] => [:environment] do |_t, args|
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
      rescue StandardError => e
        puts e.message
      end
    end
  end
end
