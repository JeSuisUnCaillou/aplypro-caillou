class PfmpStateMachine
  include Statesman::Machine

  state :pending, initial: true

  def state_to_badge
    :new
  end
end
