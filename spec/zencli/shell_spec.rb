require 'spec_helper'

describe ZenCLI::Shell do
  before { allow(ZenCLI::Log).to receive(:write) }

  describe '.failed!' do
    before(:all){ ZenCLI::Shell.failed!(404) }
    it{expect(ZenCLI::Shell.instance_variable_get('@failed')).to be_true}
    it{expect(ZenCLI::Shell.instance_variable_get('@status')).to eq(404)}
  end

  describe '.failed?' do
    context 'when failed' do
      before(:all){ ZenCLI::Shell.failed!('bad') }
      it{expect(ZenCLI::Shell.failed?).to be_true}
    end

    context 'when not failed' do
      before(:all){ ZenCLI::Shell.instance_variable_set('@failed', false) }
      it{expect(ZenCLI::Shell.failed?).to be_false}
    end
  end

  describe '.status' do
    context 'with a status' do
      before(:all){ ZenCLI::Shell.instance_variable_set('@status', 200) }
      it{expect(ZenCLI::Shell.status).to eq(200)}
    end

    context 'without a status' do
      before(:all){ ZenCLI::Shell.instance_variable_set('@status', nil) }
      it{expect(ZenCLI::Shell.status).to eq(0)}
    end
  end

  describe '.[]' do
    let(:command){'foo'}
    it 'runs the command' do
      ZenCLI::Shell.should_receive(:run).with(command)
      ZenCLI::Shell[command]
    end
  end

  describe '.run' do
    before(:all){ ZenCLI::Shell.instance_variable_set('@failed', false) }

    context 'silent' do
      let(:command){'ls'}

      it 'runs the command' do
        ZenCLI::Shell.should_receive(:run_without_output).with(command, {silent: true})
        ZenCLI::Shell.run(command, silent: true)
      end

      it 'logs the command' do
        allow(ZenCLI::Shell).to receive(:run_without_output).and_return(true)
        ZenCLI::Log.should_receive(:write).once.with("$ #{command}\n")
        ZenCLI::Shell.run(command, silent: true)
      end
    end

    context 'noisy' do
      let(:command){'ls'}

      it 'runs the command' do
        allow(ZenCLI::Log).to receive(:info)
        ZenCLI::Shell.should_receive(:run_with_output).with(command, {})
        ZenCLI::Shell.run(command)
      end

      it 'logs the command' do
        allow(ZenCLI::Shell).to receive(:run_with_output).and_return(true)
        ZenCLI::Log.should_receive(:info).once.with(
          "$ #{command}", arrows: false, color: :yellow
        )
        ZenCLI::Shell.run(command)
      end
    end
  end

  describe '.run_with_output' do
    let(:command){'ls'}
    let(:response){"foo\nbar"}

    before(:each){
      ZenCLI::Shell.should_receive(:run_with_result_check).with(command,{}).and_return(response)
      ZenCLI::Shell.should_receive(:puts).with(Regexp.new(response))
    }

    subject{ ZenCLI::Shell.run_with_output(command) }
    it{expect(subject).to eq(response)}
  end

  describe '.run_without_output' do
    let(:command){'ls'}
    let(:response){"foo\nbar"}

    before(:each){
      ZenCLI::Shell.should_receive(:run_with_result_check).with(command,{}).and_return(response)
    }

    subject{ ZenCLI::Shell.run_with_output(command) }
  end

  describe '.run_with_result_check' do
    context 'successful' do
      let(:command){'ls'}
      let(:response){"foo\nbar"}

      before(:each){
        ZenCLI::Shell.should_receive(:`).with(command).and_return(response)
      }

      subject{ZenCLI::Shell.run_with_result_check(command)}
      it{expect(subject).to eq(response)}
    end

    context 'unsuccessful' do
      let(:command){'ls'}
      let(:response){'100'}

      before(:each){
        allow(ZenCLI::Shell).to receive(:last_exit_status).and_return(response)
        ZenCLI::Shell.should_receive(:`).with(command).and_return(response)
        ZenCLI::Shell.should_receive(:puts).with(Regexp.new(response))
        ZenCLI::Log.should_receive(:info).with(/aborted/, color: :red)
        ZenCLI::Log.should_receive(:info).with(/exit status: #{response}/i, color: :red, indent: true)
        ZenCLI::Log.should_receive(:info).with(/following commands manually/, color: :red)
      }

      subject{ZenCLI::Shell.run_with_result_check(command)}
      it{expect(subject).to eq(response)}
    end
  end

end
