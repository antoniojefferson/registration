require 'rails_helper'
require 'spec_helper'

describe Citizen do

  context 'relationship' do
    it { is_expected.to have_one(:address).dependent(:destroy) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :full_name }
    it { is_expected.to validate_presence_of :cpf }
    it { is_expected.to validate_presence_of :cns }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :birth_date }
    it { is_expected.to validate_presence_of :phone }

    context 'when you have CPF' do
      let!(:citizen) { create(:citizen) }

      subject { described_class.new cpf: cpf }

      context 'when the CPF already exists' do
        let!(:cpf) { citizen.cpf }

        it 'returns error' do
          subject.valid?

          expect(subject.errors[:cpf]).to be_present
        end
      end

      context 'when the CPF does not exist' do
        let(:cpf) { '98636771080' }

        it 'does not return error' do
          subject.valid?

          expect(subject.errors[:cpf]).to be_empty
        end
      end

      context 'when the CPF is empty' do
        let(:cpf) { '' }

        it 'returns error' do
          subject.valid?

          expect(subject.errors[:cpf]).to contain_exactly 'não pode ficar em branco'
        end
      end
    end

    context 'when you have CNS' do
      let!(:citizen) { create(:citizen) }

      subject { described_class.new cns: cns }

      context 'when the CNS already exists' do
        let!(:cns) { citizen.cns }

        it 'returns error' do
          
          subject.valid?

          expect(subject.errors[:cns]).to be_present
        end
      end

      context 'when the CNS does not exist' do
        let(:cns) { '164162882070006' }

        it 'does not return error' do
          subject.valid?

          expect(subject.errors[:cns]).to be_empty
        end
      end

      context 'when the CNS is empty' do
        let(:cns) { '' }

        it 'returns error' do
          subject.valid?

          expect(subject.errors[:cns]).to contain_exactly 'não pode ficar em branco'
        end
      end
    end

    context 'when you have email' do
      let!(:citizen) { create(:citizen) }

      subject { described_class.new email: email }

      context 'when the email already exists' do
        let!(:email) { citizen.email }

        it 'returns error' do
          
          subject.valid?

          expect(subject.errors[:email]).to be_present
        end
      end

      context 'when email does not exist' do
        let(:email) { 'marcos.souza@gmail.com' }

        it 'does not return error' do
          subject.valid?

          expect(subject.errors[:email]).to be_empty
        end
      end

      context 'when email format is valid' do
        let(:email) { 'email@email.com' }

        it 'does not have error to email' do
          subject.valid?

          expect(subject.errors[:email]).to be_empty
        end
      end

      context 'when email format is invalid' do
        let(:email) { 'email@.com' }

        it 'has error to email' do
          subject.valid?

          expect(subject.errors[:email]).to contain_exactly I18n.t('activerecord.errors.models.citizen.attributes.email.invalid')
        end
      end

      context 'when email is empty' do
        let(:email) { '' }

        it 'returns error' do
          subject.valid?

          expect(subject.errors[:email]).to include 'não pode ficar em branco'
        end
      end

    end

    describe 'nested_attributes' do
      it { is_expected.to accept_nested_attributes_for(:address) }
    end

  end
end
