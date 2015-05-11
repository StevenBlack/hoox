require 'minitest_helper'

class TestMarkdown < Minitest::Test

  def setup
    @markdown_hyperlink_hook = Hoox::MarkdownHyperlinkHook.new
  end

  def test_MarkdownHyperlinkHook
    # Ensure the number of candidates match the number of outcomes
    test_string = File.read('./test/fixtures/markdownlinks.md')
    linkcandidates  = test_string.scan(" [").count
    imagecandidates = test_string.scan("![").count
    new_string = @markdown_hyperlink_hook.process( test_string )
    assert_equal( linkcandidates, new_string.scan("<a").count, "Markdown link problem")
    assert_equal( imagecandidates, new_string.scan("<img").count, "Markdown image link problem")
  end

end
