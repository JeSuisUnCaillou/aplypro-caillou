# frozen_string_literal: true

class Payment < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: PaymentTransition,
    initial_state: PaymentStateMachine.initial_state,
    ]

  has_many :transitions, class_name: "PaymentTransition", dependent: :destroy

  belongs_to :pfmp

  validates :amount, numericality: { greated_than: 0 }

  def state_machine
    @state_machine ||= PaymentStateMachine.new(
      self,
      transition_class: PaymentTransition,
      association_name: :transitions
    )
  end

  def process!
    state_machine.transition_to!(:processing)
  end

  def complete!
    state_machine.transition_to!(:success)
  end

  def fail!
    state_machine.transition_to!(:failed)
  end

  delegate :can_transition_to?,
           :current_state, :history, :last_transition, :last_transition_to,
           :transition_to!, :transition_to, :in_state?, to: :state_machine
end
