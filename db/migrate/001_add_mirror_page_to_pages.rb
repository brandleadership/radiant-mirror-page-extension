class AddMirrorPageToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :mirror_page, :integer
  end

  def self.down
    remove_column :pages, :mirror_page
  end
end