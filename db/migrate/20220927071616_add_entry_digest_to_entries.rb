class AddEntryDigestToEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :entries, :entry_digest, :string
  end
end
