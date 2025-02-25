# frozen_string_literal: true

class Student < ApplicationRecord
  self.primary_key = "ine"

  validates :ine, :first_name, :last_name, :birthdate, presence: true

  has_many :schoolings, dependent: :destroy
  has_many :classes, through: :schoolings, source: "classe"

  has_many :pfmps, -> { order "pfmps.start_date" }, through: :schoolings

  has_one :current_schooling, class_name: "Schooling", dependent: :destroy
  has_one :classe, through: :current_schooling

  has_one :establishment, through: :classe
  has_many :payments, through: :pfmps

  has_many :ribs, dependent: :destroy
  has_one :rib, -> { where(archived_at: nil) }, dependent: :destroy, inverse_of: :student

  def to_s
    full_name
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def index_name
    [last_name, first_name].join(" ")
  end

  def used_allowance
    payments.in_state(:success).map(&:amount).sum
  end

  def allowance_left
    current_schooling.mef.wage.yearly_cap - used_allowance
  end
end
