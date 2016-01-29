require 'spec_helper.rb'

describe 'stash' do
  describe 'stash::backup' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os} #{facts}" do
          let(:facts) do
            facts
          end

          context 'install stash backup client with default params' do
            it 'should deploy stash backup client 1.9.1 from tar.gz' do
              should contain_archive("/tmp/stash-backup-distribution-#{BACKUP_VERSION}.tar.gz").with(
                'source' => "https://maven.atlassian.com/public/com/atlassian/stash/backup/stash-backup-distribution/#{BACKUP_VERSION}/stash-backup-distribution-#{BACKUP_VERSION}.tar.gz",
                'extract_path' => '/opt/stash-backup',
                'creates' => "/opt/stash-backup/stash-backup-client-#{BACKUP_VERSION}/lib",
                'user' => 'stash',
                'group' => 'stash',
              )
            end

            it 'should manage the stash-backup directories' do
              should contain_file('/opt/stash-backup').with(
                'ensure' => 'directory',
                'owner'  => 'stash',
                'group'  => 'stash'
              )
              should contain_file("/opt/stash-backup/stash-backup-client-#{BACKUP_VERSION}").with(
                'ensure' => 'directory',
                'owner'  => 'stash',
                'group'  => 'stash'
              ).that_requires("Archive[/tmp/stash-backup-distribution-#{BACKUP_VERSION}.tar.gz]")

              should contain_file('/opt/stash-backup/archives').with(
                'ensure' => 'directory',
                'owner'  => 'stash',
                'group'  => 'stash'
              )
            end
            it 'should manage the backup cron job' do
              should contain_cron('Backup Stash').with(
                'ensure'  => 'present',
                'command' => "/usr/bin/java -Dstash.password=\"password\" -Dstash.user=\"admin\" -Dstash.baseUrl=\"http://localhost:7990\" -Dstash.home=/home/stash -Dbackup.home=/opt/stash-backup/archives -jar /opt/stash-backup/stash-backup-client-#{BACKUP_VERSION}/stash-backup-client.jar",
                'user'    => 'stash',
                'hour'    => '5',
                'minute'  => '0',
              )
            end
            it 'should remove old archives' do
              should contain_tidy('remove_old_archives').with(
                'path'    => '/opt/stash-backup/archives',
                'age'     => '4w',
                'matches' => '*.tar',
                'type'    => 'mtime',
                'recurse' => 1,
              )
            end
          end

          context 'should contain custom java path' do
            let(:params) {{
              :javahome  => '/java/path',
            }}
            it do
              should contain_class('stash').with_javahome('/java/path')
              should contain_cron('Backup Stash').with(
                'command' => "/java/path/bin/java -Dstash.password=\"password\" -Dstash.user=\"admin\" -Dstash.baseUrl=\"http://localhost:7990\" -Dstash.home=/home/stash -Dbackup.home=/opt/stash-backup/archives -jar /opt/stash-backup/stash-backup-client-#{BACKUP_VERSION}/stash-backup-client.jar",
                )
            end
          end

          context 'should contain custom backup client version' do
            let(:params) {{
              :backupclient_version  => '99.43.111',
            }}
            it do
              should contain_archive('/tmp/stash-backup-distribution-99.43.111.tar.gz').with(
                'source' => 'https://maven.atlassian.com/public/com/atlassian/stash/backup/stash-backup-distribution/99.43.111/stash-backup-distribution-99.43.111.tar.gz',
                'extract_path' => '/opt/stash-backup',
                'creates' => '/opt/stash-backup/stash-backup-client-99.43.111/lib',
                'user' => 'stash',
                'group' => 'stash',
              )
              should contain_file('/opt/stash-backup/stash-backup-client-99.43.111').with(
                'ensure' => 'directory',
                'owner'  => 'stash',
                'group'  => 'stash'
              )
              should contain_cron('Backup Stash').with(
                'command' => '/usr/bin/java -Dstash.password="password" -Dstash.user="admin" -Dstash.baseUrl="http://localhost:7990" -Dstash.home=/home/stash -Dbackup.home=/opt/stash-backup/archives -jar /opt/stash-backup/stash-backup-client-99.43.111/stash-backup-client.jar',
              )
            end
          end

          context 'should contain custom backup home' do
            let(:params) {{
              :backup_home   => '/my/backup',
            }}
            it do
              should contain_class('stash').with_backup_home(%r{/my/backup})
              should contain_file('/my/backup/archives').with(
                'ensure' => 'directory',
                'owner'  => 'stash',
                'group'  => 'stash'
              )
              should contain_cron('Backup Stash').with(
                'command' => "/usr/bin/java -Dstash.password=\"password\" -Dstash.user=\"admin\" -Dstash.baseUrl=\"http://localhost:7990\" -Dstash.home=/home/stash -Dbackup.home=/my/backup/archives -jar /my/backup/stash-backup-client-#{BACKUP_VERSION}/stash-backup-client.jar",
              )
            end
          end

          context 'should contain custom backup user and password' do
            let(:params) {{
              :backupuser => 'myuser',
              :backuppass => 'mypass',
            }}
            it do
              should contain_class('stash').with_backupuser('myuser').with_backuppass('mypass')
              should contain_cron('Backup Stash').with(
                'command' => "/usr/bin/java -Dstash.password=\"mypass\" -Dstash.user=\"myuser\" -Dstash.baseUrl=\"http://localhost:7990\" -Dstash.home=/home/stash -Dbackup.home=/opt/stash-backup/archives -jar /opt/stash-backup/stash-backup-client-#{BACKUP_VERSION}/stash-backup-client.jar",
              )
            end
          end

          context 'should remove old archives' do
            let(:params) {{
              :backup_keep_age => '1y',
              :backup_home     => '/my/backup',
            }}
            it do
              should contain_tidy('remove_old_archives').with(
                'path' => '/my/backup/archives',
                'age'  => '1y',
              )
            end
          end
        end
      end
    end
  end
end
