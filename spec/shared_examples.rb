shared_examples_for "a timestamped model" do
  it { should have_db_column(:updated_at).of_type(:datetime) }
  it { should have_db_column(:created_at).of_type(:datetime) }
end