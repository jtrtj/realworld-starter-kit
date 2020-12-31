require './db/database'

describe Database do
  context '#conn' do
    it 'returns a Sequel database connection' do
      DB = described_class.instance.conn
      expect(DB).to be_a(Sequel::Postgres::Database)
      expect(DB.opts[:adapter]).to eq('postgres')
      expect(DB.opts[:host]).to eq(ENV.fetch('DB_HOST'))
      expect(DB.opts[:database]).to eq(ENV.fetch('DB_NAME'))
      expect(DB.opts[:user]).to eq(ENV.fetch('DB_USER'))
      expect(DB.opts[:password]).to eq(ENV.fetch('DB_PASSWORD'))
    end
  end
end
