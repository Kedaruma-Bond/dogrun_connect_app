class DeleteColumnFromEntries < ActiveRecord::Migration[7.0]
  def change
    remove_column :entries, :entry_digest, :string
  end
end
