require 'rails_helper'

RSpec.describe 'application creation' do
  describe 'the application new' do
    it 'renders the new form' do
      visit '/applications/new'

      expect(page).to have_content('New Application')
      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('Street address')
      expect(find('form')).to have_content('City')
      expect(find('form')).to have_content('State')
      expect(find('form')).to have_content('Zip code')
    end
  end

  describe 'the application create' do
    context 'given valid data' do
      it 'creates the application' do
        visit '/applications/new'

        fill_in 'Name', with: 'P. Sherman'
        fill_in 'Street address', with: '42 Wallaby Way'
        fill_in 'City', with: 'Denver'
        fill_in 'State', with: 'Colorado'
        fill_in 'Zip code', with: '80202'
        click_button 'Submit'

        expect(page).to have_current_path("/applications/#{Application.last.id}")
        expect(page).to have_content('P. Sherman')
      end
    end

    context 'given invalid data' do
      it 're-renders the new form' do
        visit '/applications/new'

        fill_in 'Name', with: 'Larry'
        click_on "Submit"
        
        expect(page).to have_content("Error: Street address can't be blank, City can't be blank, State can't be blank, Zip code can't be blank")
        expect(current_path).to eq('/applications/new')
      end
    end
  end
end
