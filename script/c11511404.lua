--SW Tadakatsu Honda‍
function c11511404.initial_effect(c)
	c:SetUniqueOnField(1,0,11511404)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11511404)
	e1:SetCondition(c11511404.spcon)
	e1:SetTarget(c11511404.sptg)
	e1:SetOperation(c11511404.spop)
	c:RegisterEffect(e1)
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetCondition(c11511404.recon)
	e2:SetValue(LOCATION_HAND)
	c:RegisterEffect(e2)
	--battle destroy
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdcon)
	e3:SetTarget(c11511404.tg)
	e3:SetOperation(c11511404.op)
	c:RegisterEffect(e3)
	--indestructable count
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetValue(c11511404.valcon)
	c:RegisterEffect(e4)
end
function c11511404.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c11511404.spfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0xffb) and c:GetLevel()==4 and c:IsPreviousLocation(LOCATION_HAND)
end
function c11511404.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11511404.spfilter,1,nil,tp)
end
function c11511404.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11511404.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11511404.recon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY) 
end
function c11511404.filter(c)
	return c:IsDestructable() and c:IsFacedown()
end
function c11511404.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsFacedown() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(c11511404.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c11511404.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11511404.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
