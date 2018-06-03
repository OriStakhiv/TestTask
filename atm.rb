require 'yaml'


class ATM
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def login
    config = YAML.load_file('config.yml')
    loop do
      puts 'Please Enter Your Account Number:'
      account_number = gets.chomp
      
      if found_account(config, account_number).nil?
        puts 'ERROR: WRONG ACCOUNT NUMBER'
        login
      else

        puts 'Enter Your Password:'
        account_pass = gets.chomp
      end

      if account_pass == found_account(config, account_number)['password']
        puts "Hello, #{found_account(config, account_number)['name']}"
        transaction
      else
        log_error
      end
    end
  end

  def log_error
    puts 'ERROR: ACCOUNT NUMBER AND PASSWORD DON\'T MATCH'
  end

  def found_account(config, number)
    @found_num = config['accounts'][number.to_i]
  end

  def transaction
    loop do
      puts "Please Choose From the Following Options:\n"
      options = [
        '1 - Display Balance',
        '2 - Withdraw',
        '3 - Log Out'
      ]
      puts options.join("\n")

      case gets.chomp.to_i
      when 1
        display_balance
      when 2
        withdraw
      when 3
        logout
      else
        puts 'Error. Try again!'
      end
    end
  end

  def logout
    puts " #{@found_num['name']}, Thank You For Using Our ATM. Good-Bye!"
    login
  end

  def display_balance
    puts "Your balance is: #{@found_num['balance']} $"
    transaction
  end

  def withdraw
    config = YAML.load_file('config.yml')

    puts "Enter Amount You Wish to Withdraw: "
    amount = gets.chomp.to_i

    if amount <= atm_balance(config)
      withdraw_process(amount, config)
    else
      
      puts 'ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT: '
      withdraw

    end
 end

  def withdraw_process(amount, config)
    account_money = []
    atm_banknotes = Array(config['banknotes'])
    all_banknotes = []
    atm_banknotes.each { |key, value| value.times { all_banknotes.push(key) } }
    i = 0
    while amount >= 0

      if  amount > all_banknotes[i]
        i += 1
      else
        amount -= all_banknotes[i]
        account_money.push(all_banknotes.delete_at(i))
        i -= 1
        if i > all_banknotes.each.count
          banknotes_error
          new_atm_banknotes(config, account_money, atm_banknotes)
          withdraw
        end
      end
    end
  end

  def new_atm_banknotes(_config, account_money, atm_banknotes)
    account_money.each { |banknote| atm_banknotes[banknote] -= 1 }
    end

  def banknotes_error
    puts 'ERROR: There is no required number of banknotes in atm!!! Try a different amount!'
  end

  def atm_balance(config)
    config['banknotes'].reduce(0){ |sum, (key, value)| sum + (key * value) }
  end
end

account = ATM.new('')
account.login
