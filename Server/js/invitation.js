$(function() {
                    // uuid generate utility method 
                    function uuid() {
                        var uuid = "", i, random;
                        for (i = 0; i < 32; i++) {
                			random = Math.random() * 16 | 0;
                			
                			if (i == 8 || i == 12 || i == 16 || i == 20) {
                				uuid += "-"
                			}
                			uuid += (i == 12 ? 4 : (i == 16 ? (random & 3 | 8) : random)).toString(16);
                		}
                		return uuid;
                	}
                	
                    var account = {};
                    $.getJSON("signup.php?callback=?",{unique:uuid()},
                        function(data, status){
                            account = data;
                			console.log(account);
                            
                			if( account['status'] == 'createAccount'){
	                			if( account['title'] != undefined ){
		                			$('#headerTitle').text(account['title']);
	                			}else{
		                			$('#headerTitle').text('サインアップ');	
	                			}
	                			
	                			if( account['message'] != undefined ){
		                			$('div#message').html( '<div>' + account['message'] + '</div>' );
		                		}else{
	                				$('div#message').html( '<div>ようこそ' + account['username'] + 'さん。アカウント作成のためにパスワードを入力してください。</div>' );
		                		}
                			}else if( account['status'] == 'succeedAccount' ){
	                			
	                			if( account['title'] != undefined ){
		                			$('#headerTitle').text(account['title']);
	                			}else{
		                			$('#headerTitle').text('成功');
		                		}
	                			
	                			if( account['message'] != undefined ){
		                			$('div#message').html( '<div>' + account['message'] + '</div>' );
		                		}else{
	        	        			$('div#message').html( '<div>' + account['username'] + 'さん。アカウント作成が完了しました。以下のボタンをタップしてアプリケーションを起動してください。</div>' );
		                		}
	                			
        	        			if( account['buttonTitile'] != undefined ){
        	        				$('a#openApplication.ui-btn-text' ).text(account['buttonTitile']);
                                }

		                        $('a#openApplication' ).href ='';
		                        $('a#openApplication').click(function() {
		                             location.href = account['loginURL'];
		                        });
                                
                			}else if( account['status'] == 'failureExistUser' ){
	                			if( account['title'].length != undefined ){
		                			$('#headerTitle').text(account['title']);
	                			}else{
		                			$('#headerTitle').text('既存のユーザーです。');
	                			}
	                			
	                			if( account['message'] != undefined ){
		                			$('div#message').html( '<div>' + account['message'] + '</div>' );
	                			}else{
	        	        			$('div#message').html( '<div>すでに追加済みのユーザです。</div>' );
        	        			}
        	        			
        	        			if( account['buttonTitile'] != undefined  ){
        	        				$('a#openApplication.ui-btn-text' ).text(account['buttonTitile']);
                                }
                                
		                        $('a#openApplication' ).href ='';
		                        $('a#openApplication').click(function() {
		                             location.href = account['loginURL'];
		                        });
		                        
		                    }else if( account['status'] == 'failureTimeout' ){
	                			if( account['title'] != undefined  ){
		                			$('#headerTitle').text(account['title']);
	                			}else{
		                			$('#headerTitle').text('タイムアウト');
	                			}
			                    
			                    if( account['message'] != undefined  ){
				                    $('div#message').html( '<div>' + account['message'] + '</div>' );
				                }else{
	        	        			$('div#message').html( '<div>' + account['username'] + 'さん。アカウント作成の招待はタイムアウトしました。再度招待をリクエストしてください。</div>' );
				                }
				                
		                    }

                    	}
                    );
                
                	$('input#submitCreateUserAccount').click(function() {
                        if( $("input#password").val().length <= 0 ){
                            alert("パスワードを入力してください。");
                            return false;
                        }
                    
                        if( $("input#password").val().length < 6 ){
                            alert("6文字以上。英数を組み合わせたパスワードを指定してください。");
                            return false;
                        }
                    
                        if( $("input#confirmpassword").val().length <= 0 ){
                            alert("パスワード(確認)を入力してください。");
                            return false;
                        }
                    
                        var password = $("input#password").val().trim();
                        var confirmPassword = $("input#confirmpassword").val().trim();
                        if( password != confirmPassword ){
                            alert("パスワードと確認パスワードの内容が異なります。");
                            return false;
                        }
                        return true;
                    });
                });