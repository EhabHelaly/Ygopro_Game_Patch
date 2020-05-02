--Vortex Lethality
function c11511520.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11511517,aux.FilterBoolFunction(c11511520.filterF),1,true)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c11511520.tg)
	e1:SetOperation(c11511520.op)
	c:RegisterEffect(e1)
end
function c11511520.filterF(c)
	if not Card.IsFusionAttribute then Card.IsFusionAttribute = Card.IsAttribute end
	return c:IsFusionSetCard(0xffa) and c:IsFusionAttribute(ATTRIBUTE_LIGHT)
end
function c11511520.filter(c,tp,race)
	return c:IsControler(1-tp) and c:IsRace(race)
end
function c11511520.filterSP(c,e,tp,eg)
	return c:IsSetCard(0xffa) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and eg:IsExists(c11511520.filter,tp,nil,tp,c:GetRace()) 
end
function c11511520.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c11511520.filterSP,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,eg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c11511520.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11511520.filterSP,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,eg)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
