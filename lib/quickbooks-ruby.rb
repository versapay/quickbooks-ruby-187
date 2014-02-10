require 'bigdecimal'
require 'json'
require 'iconv'
require 'roxml'

module ROXML::ClassMethods::Declarations
  def xml_accessor(*syms, &block)
    xml_attr(*syms, &block).each do |attr|
      add_reader(attr, syms[1][:as])
      attr_writer(attr.attr_name)
    end
  end

  def add_reader(attr, as)
    define_method(attr.accessor) do
      if instance_variable_get(attr.instance_variable_name).nil?
        instance_variable_set(attr.instance_variable_name, attr.default)
      end
      result = instance_variable_get(attr.instance_variable_name)
      if result.respond_to?(:first) && !as.is_a?(Array)
        return instance_variable_get(attr.instance_variable_name).first
      else
        return instance_variable_get(attr.instance_variable_name)
      end
    end
  end
end

require 'logger'
require 'nokogiri'
require 'active_model'
require 'cgi'
require 'uri'
require 'date'
require 'forwardable'
require 'oauth'
require 'quickbooks/util/logging'
require 'quickbooks/util/http_encoding_helper'
require 'quickbooks/util/name_entity'

#== Models
require 'quickbooks/model/base_model'
require 'quickbooks/model/base_reference'
require 'quickbooks/model/meta_data'
require 'quickbooks/model/custom_field'
require 'quickbooks/model/sales_item_line_detail'
require 'quickbooks/model/sub_total_line_detail'
require 'quickbooks/model/discount_override'
require 'quickbooks/model/payment_line_detail'
require 'quickbooks/model/account_based_expense_line_detail'
require 'quickbooks/model/line'
require 'quickbooks/model/item'
require 'quickbooks/model/account'
require 'quickbooks/model/check_payment'
require 'quickbooks/model/credit_card_payment'
require 'quickbooks/model/telephone_number'
require 'quickbooks/model/other_contact_info'
require 'quickbooks/model/email_address'
require 'quickbooks/model/web_site_address'
require 'quickbooks/model/physical_address'
require 'quickbooks/model/linked_transaction'
require 'quickbooks/model/invoice_line_item'
require 'quickbooks/model/tax_line_detail'
require 'quickbooks/model/tax_line'
require 'quickbooks/model/transaction_tax_detail'
require 'quickbooks/model/tax_rate'
require 'quickbooks/model/invoice'
require 'quickbooks/model/company_info'
require 'quickbooks/model/customer'
require 'quickbooks/model/sales_receipt'
require 'quickbooks/model/payment'
require 'quickbooks/model/payment_method'
require 'quickbooks/model/credit_memo'
require 'quickbooks/model/bill_line_item'
require 'quickbooks/model/bill'
require 'quickbooks/model/bill_payment_line_item'
require 'quickbooks/model/bill_payment_check'
require 'quickbooks/model/bill_payment_credit_card'
require 'quickbooks/model/bill_payment'
require 'quickbooks/model/vendor'
require 'quickbooks/model/employee'
require 'quickbooks/model/term'
require 'quickbooks/model/markup_info'
require 'quickbooks/model/group_line_detail'
require 'quickbooks/model/item_based_expense_line_detail'
require 'quickbooks/model/purchase_line_item'
require 'quickbooks/model/purchase'
require 'quickbooks/model/purchase_order'
require 'quickbooks/model/vendor_credit'
require 'quickbooks/model/estimate'

#== Services
require 'quickbooks/service/base_service'
require 'quickbooks/service/service_crud'
require 'quickbooks/service/company_info'
require 'quickbooks/service/customer'
require 'quickbooks/service/invoice'
require 'quickbooks/service/item'
require 'quickbooks/service/sales_receipt'
require 'quickbooks/service/account'
require 'quickbooks/service/payment_method'
require 'quickbooks/service/credit_memo'
require 'quickbooks/service/bill'
require 'quickbooks/service/bill_payment'
require 'quickbooks/service/vendor'
require 'quickbooks/service/employee'
require 'quickbooks/service/payment'
require 'quickbooks/service/term'
require 'quickbooks/service/purchase'
require 'quickbooks/service/purchase_order'
require 'quickbooks/service/vendor_credit'
require 'quickbooks/service/estimate'
require 'quickbooks/service/tax_rate'

module Quickbooks
  @@logger = nil

  class << self
    def logger
      @@logger ||= ::Logger.new($stdout) # TODO: replace with a real log file
    end

    def logger=(logger)
      @@logger = logger
    end

    # set logging on or off
    attr_writer :log

    # Returns whether to log. Defaults to 'false'.
    def log?
      @log ||= false
    end

    def log(msg)
      if log?
        logger.info(msg)
        logger.flush if logger.respond_to?(:flush)
      end
    end
  end # << self

  class InvalidModelException < StandardError; end

  class AuthorizationFailure < StandardError; end

  class IntuitRequestException < StandardError
    attr_accessor :message, :code, :detail, :type
    def initialize(msg)
      self.message = msg
      super(msg)
    end
  end

  class Collection
    attr_accessor :entries

    # Legacy Attributes (v2)
    attr_accessor :count, :current_page

    # v3 Attributes
    attr_accessor :start_position, :max_results, :total_count
  end

end

class Object
  def public_send(method, *args)
    if respond_to?(method)
      send(method, args)
    else
      method_messing(method, *args)
    end
  end
end

class Time
  def initialize(*args)
    result = nil
    if args.length > 0
      # raise
      Time.gm(args[5], args[4], args[3], args[2], args[1], args[0])
    else
      super
    end
  end
end

# https://bitbucket.org/ged/ruby-axis/raw/ef212387adcbd567a39fa0d51eb6dc6051c416bf/lib/axis/monkeypatches.rb

# Backport of Ruby 1.9.2 URI methods to 1.8.7.
module URIFormEncoding

    TBLENCWWWCOMP_ = {} # :nodoc:
    TBLDECWWWCOMP_ = {} # :nodoc:


    # Encode given +str+ to URL-encoded form data.
    #
    # This doesn't convert *, -, ., 0-9, A-Z, _, a-z,
    # does convert SP to +, and convert others to %XX.
    #
    # This refers http://www.w3.org/TR/html5/forms.html#url-encoded-form-data
    #
    # See URI.decode_www_form_component, URI.encode_www_form
  def encode_www_form_component( str )
    # URI.encode(str)

    if TBLENCWWWCOMP_.empty?
      256.times do |i|
        TBLENCWWWCOMP_[i.chr] = '%%%02X' % i
      end
      TBLENCWWWCOMP_[' '] = '+'
      TBLENCWWWCOMP_.freeze
      warn TBLENCWWWCOMP_.inspect ##TEST CODE
    end
    return str.to_s.gsub(/[^*\-.0-9A-Z_a-z]/, (TBLENCWWWCOMP_[$1] || '+'))
  end

    # Decode given +str+ of URL-encoded form data.
    #
    # This decodes + to SP.
    #
    # See URI.encode_www_form_component, URI.decode_www_form
  def decode_www_form_component( str )
    # URI.decode(str)
    if TBLDECWWWCOMP_.empty?
      256.times do |i|
        h, l = i>>4, i&15
        TBLDECWWWCOMP_['%%%X%X' % [h, l]] = i.chr
        TBLDECWWWCOMP_['%%%x%X' % [h, l]] = i.chr
        TBLDECWWWCOMP_['%%%X%x' % [h, l]] = i.chr
        TBLDECWWWCOMP_['%%%x%x' % [h, l]] = i.chr
      end
      TBLDECWWWCOMP_['+'] = ' '
      TBLDECWWWCOMP_.freeze
    end
    raise ArgumentError, "invalid %-encoding (#{str})" unless /\A(?:%\h\h|[^%]+)*\z/ =~ str
    return str.gsub( /\+|%\h\h/, TBLDECWWWCOMP_ )
  end

    # Generate URL-encoded form data from given +enum+.
    #
    # This generates application/x-www-form-urlencoded data defined in HTML5
    # from given an Enumerable object.
    #
    # This internally uses URI.encode_www_form_component(str).
    #
    # This doesn't convert encodings of give items, so convert them before call
    # this method if you want to send data as other than original encoding or
    # mixed encoding data. (strings which is encoded in HTML5 ASCII incompatible
    # encoding is converted to UTF-8)
    #
    # This doesn't treat files. When you send a file, use multipart/form-data.
    #
    # This refers http://www.w3.org/TR/html5/forms.html#url-encoded-form-data
    #
    # See URI.encode_www_form_component, URI.decode_www_form
    def encode_www_form( enum )
        str = nil
        enum.each do |k,v|
            if str
                str << '&'
            else
                str = nil.to_s
            end
            str << encode_www_form_component(k)
            str << '='
            str << encode_www_form_component(v)
        end
        str
    end

    WFKV_ = '(?:%\h\h|[^%#=;&])' # :nodoc:

    # Decode URL-encoded form data from given +str+.
    #
    # This decodes application/x-www-form-urlencoded data
    # and returns array of key-value array.
    # This internally uses URI.decode_www_form_component.
    #
    # This refers http://www.w3.org/TR/html5/forms.html#url-encoded-form-data
    #
    # ary = URI.decode_www_form("a=1&a=2&b=3")
    # p ary #=> [['a', '1'], ['a', '2'], ['b', '3']]
    # p ary.assoc('a').last #=> '1'
    # p ary.assoc('b').last #=> '3'
    # p ary.rassoc('a').last #=> '2'
    # p Hash[ary] # => {"a"=>"2", "b"=>"3"}
    #
    # See URI.decode_www_form_component, URI.encode_www_form
    def decode_www_form( str )
        return [] if str.empty?
        unless /\A#{WFKV_}*=#{WFKV_}*(?:[;&]#{WFKV_}*=#{WFKV_}*)*\z/o =~ str
            raise ArgumentError, "invalid data of application/x-www-form-urlencoded (#{str})"
        end
        ary = []
        $&.scan(/([^=;&]+)=([^;&]*)/) do
            ary << [decode_www_form_component($1, enc), decode_www_form_component($2, enc)]
        end
        ary
      # URI.decode(str)
    end

end


unless URI.methods.include?( :encode_www_form )
    URI.extend( URIFormEncoding )
end
