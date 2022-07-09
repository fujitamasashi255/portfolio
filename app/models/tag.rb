# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id             :bigint           not null, primary key
#  name           :string
#  taggings_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#
class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy

  scope :by_questions, lambda { |questions| \
    joins(:taggings)\
      .joins("INNER JOIN answers ON answers.id = taggings.taggable_id")\
      .joins("INNER JOIN questions ON answers.question_id = questions.id")\
      .distinct\
      .where(questions: { id: questions.map(&:id) })
  }
end
