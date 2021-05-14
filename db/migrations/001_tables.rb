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

    create_table(:follows) do
      foreign_key :user_id, :users
      foreign_key :follower_id, :users
      primary_key %i[user_id follower_id], name: :follows_pk
    end

    create_table(:articles) do
      primary_key :id
      foreign_key :user_id, :users
      String :slug
      String :title
      String :description
      String :body, text: true
      DateTime :created_at
      DateTime :updated_at
      index :slug
    end
  end
end
