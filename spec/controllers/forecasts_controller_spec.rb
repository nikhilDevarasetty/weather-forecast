require 'rails_helper'

RSpec.describe ForecastsController, type: :controller do
  describe 'GET #show' do
    context 'when address is present' do
      let(:address) { 'Hyderabad' }
      let(:forecast) { double('Forecast') }

      before do
        allow(Core::Forecast).to receive(:new).with(address).and_return(forecast)
        allow(forecast).to receive(:call)
      end

      it 'assigns the address' do
        get :show, params: { address: address }
        expect(assigns(:address)).to eq(address)
      end

      it 'calls the forecast service' do
        expect(forecast).to receive(:call)
        get :show, params: { address: address }
      end

      it 'does not set error flash message' do
        get :show, params: { address: address }
        expect(flash[:error]).to be_nil
      end
    end

    context 'when address is not present' do
      it 'does not call the forecast service' do
        expect(Core::Forecast).not_to receive(:new)
        get :show
      end

      it 'does not set error flash message' do
        get :show
        expect(flash[:error]).to be_nil
      end
    end

    context 'when an exception occurs' do
      let(:address) { 'Hyderabad' }
      let(:error_message) { 'An error occurred' }

      before do
        allow(Core::Forecast).to receive(:new).with(address).and_raise(StandardError, error_message)
      end

      it 'sets the error flash message' do
        get :show, params: { address: address }
        expect(flash[:error]).to eq(error_message)
      end
    end
  end
end
