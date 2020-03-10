module ControllerHelpers
  def stub_can_ability(*args)
    allow(@controller).to receive(:current_ability) do
      ability = Object.new
      ability.extend(CanCan::Ability)
      ability.can(*args)
      ability
    end
  end

  def stub_cannot_ability(*args)
    allow(@controller).to receive(:current_ability) do
      ability = Object.new
      ability.extend(CanCan::Ability)
      ability.cannot(*args)
      ability
    end
  end
end
