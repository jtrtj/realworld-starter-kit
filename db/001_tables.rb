Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :email, null: false, unique: true
      String :username, null: false
      String :password, null: false
      String :bio
      String :image
    end
  end
end
