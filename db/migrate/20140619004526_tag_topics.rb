class TagTopics < ActiveRecord::Migration
  def change
    create_table :tag_topics do |t|
      t.string :topic
      t.integer :url_id
      t.timestamps
    end
    
    add_index(:tag_topics, :url_id)
    
    #validates(:topic, inclusion: { in: %w(news music sports technology business entertainment) } )
  end
end
