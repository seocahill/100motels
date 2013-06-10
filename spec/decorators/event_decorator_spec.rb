require 'spec_helper'

describe EventDecorator do
  let(:decorator) { EventDecorator.new(object) }
  let(:object) { create(:event) }

  it "uses a test view context from ApplicationController" do
    expect(Draper::ViewContext.current.controller).to be_an ApplicationController
  end

  context "lock" do
    pending
  end
end