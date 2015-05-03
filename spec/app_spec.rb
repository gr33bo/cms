require_relative 'spec_helper'


describe 'Hello World' do

  it 'should have hello world' do
    get '/'
    last_response.must_be :ok?
    last_response.body.must_include "Hello world!"
  end
end