require 'spec_helper'

describe ZenCLI do
  describe 'Log' do
    context 'info' do
      before { ZenCLI::Log.stub(:write) }

      it 'indents the text' do
        $stdout.should_receive(:puts).with(/\s+foo/)
        ZenCLI::Log.info('foo', indent: true)
      end

      it 'adds an arrow the text' do
        $stdout.should_receive(:puts).with(/-----> foo/)
        ZenCLI::Log.info('foo', arrows: true)
      end

      it 'colorizes the text' do
        $stdout.should_receive(:puts).with(/foo/)
        ZenCLI::Log.info('foo', color: :blue, arrows: false)
      end

      it 'does not colorize the text' do
        $stdout.should_receive(:puts).with('foo')
        ZenCLI::Log.info('foo', color: false, arrows: false)
      end
    end

    context 'with different logfile' do
      before { ZenCLI::Log.logfile = File.join(Dir.pwd, "tmp", ".zencli-log") }
      it { expect(ZenCLI::Log.logfile).to eq(File.join(Dir.pwd, "tmp", ".zencli-log")) }
      it { expect(ZenCLI::Log.write('foo')).to be_true }
    end
  end
end
