require 'ostruct'
require 'nokogiri'

require 'mingle/http'
require 'mingle/macro'

class Mingle

  attr_reader :site

  PROJECT = [:name, :identifier, :description]
  CARD = [:name, :description,
    {
      "card_type name" => :type,
      'properties property' => lambda do |node|
        name = text(node, 'name')
        value = case node[:type_description]
        when /team list/
          text(node, 'value login')
        else
          text(node, 'value')
        end
        [name.downcase, value]
      end
    }
  ]

  def initialize(site, credentials)
    @site, @http = site, Http.new(credentials)
  end

  def projects
    list(fetch(:projects), PROJECT)
  end

  def project(identifier)
    ostruct(fetch(:projects, identifier), PROJECT)
  end

  def create_project(name, options={})
    identifier = name.downcase.gsub(/[^a-z0-9_]/, '_')
    @http.post(v2(:projects), {
      "project[name]" => name,
      "project[identifier]" => identifier,
      "project[description]" => options[:description],
      "project[template]" => false,
      "template_name" => options[:template] ? "yml_#{options[:template]}_template" : nil
    })
    OpenStruct.new(:identifier => identifier, :name => name, :url => url('projects', identifier))
  end

  def cards(project)
    list(fetch(:projects, project_identifier(project), :cards), CARD)
  end

  def card(project, number)
    ostruct(fetch(:projects, project_identifier(project), :cards, number), CARD)
  end

  def create_card(project, attrs)
    params = [
      ["card[name]", attrs[:name]],
      ["card[card_type_name]", attrs[:type]],
      ["card[description]", attrs[:description]]
    ]
    Array(attrs[:attachments]).each_with_index do |attachment, i|
      path, content_type = attachment
      params << ["attachments[#{i}]", UploadIO.new(File.new(path), content_type, File.basename(path))]
    end
    Array(attrs[:properties]).each_with_index do |prop, i|
      name, value = prop
      params << ["card[properties][][name]", name]
      params << ["card[properties][][value]", value]
    end
    resp = @http.post(v2(:projects, project_identifier(project), :cards), params)
    number = resp[2]["location"].split("/").last.split('.').first
    OpenStruct.new(:number => number, :url => url('projects', project_identifier(project), 'cards', number))
  end

  def site_api_url
    gen_site_url(api_host)
  end

  def site_url
    gen_site_url(host)
  end

  private
  def project_identifier(proj)
    proj.respond_to?(:identifier) ? proj.identifier : proj.to_s
  end

  def url(*parts)
    File.join(site_url, *parts)
  end

  def api_host
    'mingle-api.thoughtworks.com' || ENV['MINGLE_API_HOST']
  end

  def host
    'mingle.thoughtworks.com' || ENV['MINGLE_HOST']
  end

  def fetch(*resources)
    dom(@http.get(v2(*resources))[1]).root
  end

  def list(dom, attrs)
    dom.children.map do |child|
      ostruct(child, attrs)
    end
  end

  def ostruct(node, attrs)
    macro = Macro.new
    OpenStruct.new(Hash[*macro.apply(node, attrs)])
  end

  def dom(xml)
    Nokogiri::XML(xml) do |config|
      config.options = Nokogiri::XML::ParseOptions::NOBLANKS | Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
    end
  end

  def v2(*parts)
    [File.join(site_api_url, 'api/v2', *parts.map(&:to_s)), 'xml'].join('.')
  end

  def gen_site_url(h)
    site =~ /^http/i ? site : "https://#{site}.#{h}"
  end
end
