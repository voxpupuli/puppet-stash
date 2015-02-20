require 'spec_helper.rb'

describe 'stash' do
  describe 'stash::backup' do
    context 'install stash backup client  with deploy module' do
      it { should contain_group('stash') }
      it { should contain_user('stash').with_shell('/bin/bash') }
      it 'should deploy stash backup client 1.6.0 from tar.gz' do
        should contain_staging__file("stash-backup-distribution-1.6.0.tar.gz")
      end
      it 'should manage the stash-backup directory' do
        should contain_file('/opt/stash-backup').with({
          'ensure' => 'directory',
          'owner'  => 'stash',
          'group'  => 'stash'
          })
      end
      it 'should manage the stash-backup archives directory' do
        should contain_file('/opt/stash-backup/archives').with({
          'ensure' => 'directory',
          'owner'  => 'stash',
          'group'  => 'stash'
          })
      end
      it 'should manage the backup cron job' do
        should contain_cron('Backup Stash').with({
          'ensure'  => 'present',
          'command' => '/usr/bin/java -Dstash.password="password" -Dstash.user="admin" -Dstash.baseUrl="http://localhost:7990" -Dstash.home=/home/stash -Dbackup.home=/opt/stash-backup/archives -jar /opt/stash-backup/stash-backup-client-1.6.0/stash-backup-client.jar',
          'user'    => 'stash',
          'hour'    => '5',
          'minute'  => '0',
          })
      end
    end
  end
end
