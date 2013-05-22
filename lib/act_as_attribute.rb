require "act_as_attribute/exceptions"
module ActAsAttributes

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods

    def get_constants
      self::AVAILABLE_ATTRIBUTES ||= []
      self::ACCEPTANCE_LEVEL ||= "error"
    end

    def method_available_as_attribute?(attribute)
      self.attribute_method?(attribute) ? true : false
    end

    def deal_with_duplicate_method(arg)
      if self::ACCEPTANCE_LEVEL == "error"
        raise Exceptions::AlreadyPresentAsAttribute
      else
        warn "Warning: Method '#{arg}' already available as attribute"
      end
    end

    def act_as_attribute(model_name, model_attr_as_key= "name", model_attr_as_value="value")

      get_constants

      self::AVAILABLE_ATTRIBUTES.each do |attr|
        if method_available_as_attribute?(attr)
          deal_with_duplicate_method(attr)
        end

        define_method(attr.underscore) do
          available_objects = self.send(model_name)
          if available_objects.map(&model_attr_as_key.to_sym).include? attr
            available_objects.send("find_by_#{model_attr_as_key}", attr).send(model_attr_as_value)
          else
            new_object = model_name.to_s.classify.constantize.create(model_attr_as_key.to_sym => attr)
            available_objects << new_object
            new_object.send(model_attr_as_value)
          end
        end

        define_method("#{attr.underscore}=") do |value|
          available_objects = self.send(model_name)
          if available_objects.map(&model_attr_as_key.to_sym).include? attr
            new_association= available_objects.send("find_by_#{model_attr_as_key}", attr)
            new_association.send("#{model_attr_as_value.to_s}=", value)
            new_association.save
          else
            new_object = model_name.to_s.classify.constantize.create(model_attr_as_key.to_sym => attr)
            new_object.send("#{model_attr_as_value}=", value)
            new_object.save
            available_objects << new_object
          end
        end
      end
    end
  end

end
ActiveRecord::Base.send :include, ActAsAttributes