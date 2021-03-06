class RolifyCreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table(:roles) do |t|
      t.timestamps

      t.string :name
      t.references :resource, polymorphic: true
    end

    create_table(:users_roles, id: false) do |t|
      t.references :user
      t.references :role
    end

    add_index(:roles, %i[name resource_type resource_id])
    add_index(:users_roles, %i[user_id role_id])
  end
end
