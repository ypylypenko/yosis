# SPDX-FileCopyrightText: 2020 Felix Wolfsteller
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class Lesson < ApplicationRecord
  extend FriendlyId
  include RankedModel

  ranks :row_order, with_same: :course_id, scope: :inactive
  ranks :row_order, with_same: :course_id, scope: :active

  belongs_to :course

  has_one_attached :video
  has_one_attached :preview_image

  validates :name, presence: true
  validates :preview_image, presence: true
  validates :video, presence: true

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where.not(active: true) }

  friendly_id :name, use: :slugged
end
