module SimpleForm
  module Inputs
    class DatepickerInput < Base
      def input
        @builder.text_field(attribute_name,input_html_options)
      end
    end
  end
end