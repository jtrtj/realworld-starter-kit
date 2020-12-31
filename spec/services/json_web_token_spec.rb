require './app/services/json_web_token'

describe JsonWebToken do
  context 'Class Methods' do
    before do
      @payload = { user_id: 1 }
      @application_secret = ENV.fetch('SECRET_KEY')
      @exp = Time.now + (24 * 60 * 60)
      @token = JsonWebToken.encode(@payload, @exp)
    end
    context '.encode' do
      it 'Creates a new token using payload and application secret with expiration time of 24 hours as default' do
        actual = JWT.decode(@token, @application_secret)
        token_payload = actual[0]
        expect(token_payload['user_id']).to eq(@payload[:user_id])
        expect(token_payload['exp']).to eq(@exp.to_i)
      end
    end
    context '.decode' do
      it 'Decodes a given token and returns a JsonWebToken::Decoded if valid' do
        token = JsonWebToken.decode(@token)
        expect(token).to be_a(JsonWebToken::Decoded)
        expect(token.user_id).to eq(@payload[:user_id])
        expect(token.exp).to eq(@exp.to_i)
      end
      it "Returns nil if token can't be decoded" do
        invalid_jwt = JWT.encode(@payload, 'not_application_secret')
        token = JsonWebToken.decode(invalid_jwt)
        expect(token).to be_nil
      end
      it 'Returns nil if token is past expiration date' do
        invalid_time = Time.now - (36 * 60 * 60)
        encoded_token = JsonWebToken.encode(@payload, invalid_time)
        invalid_token = JsonWebToken.decode(encoded_token)
        expect(invalid_token).to be_nil
      end
    end
  end
end
