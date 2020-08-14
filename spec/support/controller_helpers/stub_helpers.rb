module ControllerHelpers
  def stub_ability(user)
    Ability.new(user).tap do |ability|
      allow(@controller).to receive(:current_ability) { ability }
    end
  end
end
