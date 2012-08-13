require 'spec_helper'

describe CartsController do

  describe "show the current cart" do
    it { should render_template(:show)  }
  end

end
