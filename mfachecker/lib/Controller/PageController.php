<?php
namespace OCA\MFAChecker\Controller;

use OCA\User_SAML\UserBackend;
use OCA\User_SAML\UserData;
use OCP\IRequest;
use OCP\AppFramework\Http\TemplateResponse;
use OCP\AppFramework\Http\DataResponse;
use OCP\AppFramework\Controller;
use OCP\ISession;

class PageController extends Controller {
	private $userId;
	private UserData $userData;
	private ISession $session;
	public function __construct($AppName, IRequest $request, ISession $session, UserData $userData, $UserId){
		parent::__construct($AppName, $request);
		$this->userData = $userData;
		$this->session = $session;
		$this->userId = $UserId;
	}

	/**
	 * CAUTION: the @Stuff turns off security checks; for this page no admin is
	 *          required and no CSRF check. If you don't know what CSRF is, read
	 *          it up in the docs or you might create a security hole. This is
	 *          basically the only required method to add this exemption, don't
	 *          add it to any other method if you don't exactly know what it does
	 *
	 * @NoAdminRequired
	 * @NoCSRFRequired
	 */
	public function index() {
		$user =[];
		$result = [];
		if (!empty($this->session->get('user_saml.samlUserData'))) {
			$this->userData->setAttributes($this->session->get('user_saml.samlUserData'));
			$user = $this->userData->getAttributes();
			$result["isSamlAuthenticated"] = true;
			$result["displayName"] = $user["display_name"][0];
			$result["username"] = $user["username"][0];
			$result["mfaVerified"] = $user["mfa_verified"][0];

		}
		return new TemplateResponse('mfachecker', 'index', $result );  // templates/index.php
	}

}
