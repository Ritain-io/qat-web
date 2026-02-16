require_relative 'version'

require_relative 'page'

module QAT::Web

  #Class to represent a Web Site as a collection of {QAT::Web::Page}. These webpages should be all subclasses of a common
  #{QAT::Web::Page} abstract subclass, representing a website's generic webpage. This abstract class should be used in the
  ##manages class definition. Also the initial website's page should be declared and should be a subclass of the managed
  #domain.
  #To navigate in the website, just call the methods of the current page of the website.
  # @example Sample Website implementation.
  #   class ExampleWebsite < QAT::Web::PageManager
  #
  #     manages ExampleWebsitePage #Inherits from QAT::Web::Page
  #
  #     initial_page ExampleLoginPage #Inherits from ExampleWebsitePage
  #
  #   end
  #
  #   site_controller = ExampleWebsite.new
  #   site_controller.current_page # ExampleLoginPage instance
  #   site_controller.login
  #   site_controller.current_page # ExampleAuthenticatedPage instance
  #
  #@abstract
  #@since 1.0.0
  class PageManager

    #Define the initial page of the chosen managed domain.
    #@param page [Class] Initial page class. Must be subclass of the class defined in #manages
    #@raise [TypeError] Invalid class type defined
    def self.initial_page page
      raise TypeError.new "Initial page class #{page} is not a QAT::Web::Page subclass" unless page.is_a? Class and page.ancestors.include? QAT::Web::Page
      raise TypeError.new "Initial page class #{page} is not a #{@@manages} subclass" if @@manages and not page.ancestors.include? @@manages

      @@initial_page = page
    end


    #Define the domain's main class to manage.
    #@param page_type [Class] Domain's abstract page class. Must be subclass of QAT::Web::Page
    #@raise [TypeError] Invalid class type defined
    def self.manages page_type
      raise TypeError.new "Manage domain class #{page_type} is not an QAT::Web::Page subclass" unless page_type.is_a? Class and page_type.ancestors.include? QAT::Web::Page

      @@manages = page_type
    end

    #Initialize the page manager. Will start at the defined initial page.
    #@raise [TypeError] Invalid definition of #manages or #initial_page
    def initialize
      raise TypeError.new "No page type defined, use class definition 'manages' to define a QAT:Web::Page type to manage" unless @@manages
      raise TypeError.new "No initial page type defined, use class definition 'initial_page' to define a #{@@manages} type page as initial" unless @@initial_page

      @current_page = @@initial_page.new
    end

    #@return [QAT::Web::Page] current page object instance.
    attr_reader :current_page


    #Forwards all methods to current page.
    def method_missing(method, *args, **kwargs, &block)
      result        = @current_page.send(method, *args, **kwargs, &block)
      @current_page = result if @current_page.class.actions.include? method
      result
    end

    def respond_to_missing?(method, include_private = false)
      @current_page.respond_to?(method, include_private) || super
    end

  end
end