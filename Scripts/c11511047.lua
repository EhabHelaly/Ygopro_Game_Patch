--Flash Revoke
function c11511047.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11511047.target)
	e1:SetOperation(c11511047.activate)
	c:RegisterEffect(e1)

end
function c11511047.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff)
end
function c11511047.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c11511047.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11511047.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c11511047.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11511047.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DESTROY_REPLACE)
   		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetTarget(c11511047.reptg)
        e1:SetOperation(c11511047.repop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c11511047.rpfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c11511047.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_RULE+REASON_BATTLE)==0
		and Duel.IsExistingMatchingCard(c11511047.rpfilter,tp,0,LOCATION_MZONE,1,nil) end
	return true
end
function c11511047.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c11511047.rpfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMinGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT+REASON_REPLACE)
		else Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE) end
	end
end
