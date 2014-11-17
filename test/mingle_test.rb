require 'test_helper'

class MingleTest < Minitest::Test
  def test_projects
    mingle = create_basic_auth_mingle
    first_proj = mingle.projects.find{|proj| proj.identifier == 'your_first_project'}
    assert first_proj
    assert_equal 'Your First Project', first_proj.name
  end

  def test_find_project_by_identifier
    mingle = create_basic_auth_mingle
    first_proj = mingle.project('your_first_project')
    assert first_proj
    assert_equal 'Your First Project', first_proj.name
  end

  def test_create_project
    t = Time.now
    mingle = create_basic_auth_mingle
    project = mingle.create_project("Hello #{t.to_i}", description: "proj created at #{t}", template: 'kanban')
    assert_equal "hello_#{t.to_i}", project.identifier
    assert_equal "https://xiao-test100.mingle.thoughtworks.com/projects/hello_#{t.to_i}", project.url

    proj = mingle.project(project.identifier)
    assert_equal "proj created at #{t}", proj.description
  end

  def test_cards
    mingle = create_hmac_auth_mingle
    cards = mingle.cards('your_first_project')
    assert cards.size > 0
  end

  def test_find_card_by_number
    mingle = create_hmac_auth_mingle
    card1 = mingle.card('your_first_project', 1)
    assert_equal 'Welcome to Mingle', card1.name
    assert_equal 'Story', card1.type
    assert_equal 'New', card1.status
    assert_equal 'xli_test100', card1.owner

    card2 = mingle.card('your_first_project', 2)
    assert_equal 'card name', card2.name
    assert_equal 'Story', card2.type
    assert_equal 'New', card2.status
    assert_equal nil, card2.owner
  end

  def test_create_card
    mingle = create_hmac_auth_mingle
    card = mingle.create_card('your_first_project', name: 'card name', type: 'Story', description: 'card desc', properties: {status: 'new', priority: 'must'}, attachments: [[__FILE__, 'plain/text']])
    assert card.number
    assert_equal "https://xiao-test100.mingle.thoughtworks.com/projects/your_first_project/cards/#{card.number}", card.url

    card = mingle.card('your_first_project', card.number)
    assert_equal 'card desc', card.description
    assert_equal 'card name', card.name
    assert_equal 'Story', card.type
    assert_equal 'New', card.status
    assert_equal 'Must', card.priority
  end
end