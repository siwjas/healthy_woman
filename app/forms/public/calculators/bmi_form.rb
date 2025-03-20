module Public
  module Calculators
    class BmiForm
      include ActiveModel::Model
      
      attr_accessor :weight, :height, :weight_goal, :notes
      
      validates :weight, presence: true, numericality: { greater_than: 0 }
      validates :height, presence: true, numericality: { greater_than: 0 }
      validates :weight_goal, numericality: { greater_than: 0 }, allow_blank: true

      def initialize(attributes = {})
        attributes = attributes.transform_keys(&:to_sym) if attributes.present?
        super(attributes)
      end

      def attributes
        {
          weight: weight,
          height: height,
          weight_goal: weight_goal,
          notes: notes
        }
      end

      def attributes=(attrs)
        attrs.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end
    end
  end
end 